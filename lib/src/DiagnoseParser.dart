import 'dart:core';
import 'Util.dart';
import 'ConfigurationStack.dart';
import 'IntTuple.dart';
import 'Monitor.dart';
import 'ParseErrorCodes.dart';
import 'ParseTable.dart';
import 'TokenStream.dart';

const int STACK_INCREMENT = 256;

const int BUFF_UBOUND = 31, BUFF_SIZE = 32, MAX_DISTANCE = 30, MIN_DISTANCE = 3;

class RepairCandidate {
  int symbol = 0;
  int location = 0;
}

class PrimaryRepairInfo {
  int distance = 0;
  int misspellIndex = 0;
  int code = 0;
  int bufferPosition = 0;
  int symbol = 0;

  PrimaryRepairInfo([PrimaryRepairInfo? clone]) {
    if (null != clone) {
      copy(clone);
    }
  }

  void copy(PrimaryRepairInfo c) {
    distance = c.distance;
    misspellIndex = c.misspellIndex;
    code = c.code;
    bufferPosition = c.bufferPosition;
    symbol = c.symbol;
  }
}

class SecondaryRepairInfo {
  int code = 0;
  int distance = 0;
  int bufferPosition = 0;
  int stackPosition = 0;
  int numDeletions = 0;
  int symbol = 0;

  bool recoveryOnNextStack = false;
}

class StateInfo {
  int state = 0;
  int next = 0;

  StateInfo(int state, int next) {
    this.state = state;
    this.next = next;
  }
}

class DiagnoseParser {
  Monitor? monitor;
  late TokenStream tokStream;

  late ParseTable prs;
  int ERROR_SYMBOL = 0,
      SCOPE_SIZE = 0,
      MAX_NAME_LENGTH = 0,
      NT_OFFSET = 0,
      LA_STATE_OFFSET = 0,
      NUM_RULES = 0,
      NUM_SYMBOLS = 0,
      START_STATE = 0,
      EOFT_SYMBOL = 0,
      EOLT_SYMBOL = 0,
      ACCEPT_ACTION = 0,
      ERROR_ACTION = 0;

  List<int> list = [];

  int maxErrors = 0;

  int maxTime = 0;

  void setMonitor(Monitor monitor) {
    this.monitor = monitor;
  }

  //
  // maxErrors is the maximum number of errors to be repaired
  // maxTime is the maximum amount of time allowed for diagnosing
  // but at least one error must be diagnosed
  //
  DiagnoseParser(TokenStream tokStream, ParseTable prs,
      [int maxErrors = 0, int maxTime = 0, Monitor? monitor]) {
    this.monitor = monitor;
    this.maxErrors = maxErrors;
    this.maxTime = maxTime;
    this.tokStream = tokStream;
    this.prs = prs;
    main_configuration_stack = ConfigurationStack(prs);

    ERROR_SYMBOL = prs.getErrorSymbol();
    SCOPE_SIZE = prs.getScopeSize();
    MAX_NAME_LENGTH = prs.getMaxNameLength();
    NT_OFFSET = prs.getNtOffset();
    LA_STATE_OFFSET = prs.getLaStateOffset();
    NUM_RULES = prs.getNumRules();
    NUM_SYMBOLS = prs.getNumSymbols();
    START_STATE = prs.getStartState();
    EOFT_SYMBOL = prs.getEoftSymbol();
    EOLT_SYMBOL = prs.getEoltSymbol();
    ACCEPT_ACTION = prs.getAcceptAction();
    ERROR_ACTION = prs.getErrorAction();
    list = List.filled(NUM_SYMBOLS + 1, 0);
  }

  int rhs(int index) {
    return prs.rhs(index);
  }

  int baseAction(int index) {
    return prs.baseAction(index);
  }

  int baseCheck(int index) {
    return prs.baseCheck(index);
  }

  int lhs(int index) {
    return prs.lhs(index);
  }

  int termCheck(int index) {
    return prs.termCheck(index);
  }

  int termAction(int index) {
    return prs.termAction(index);
  }

  int asb(int index) {
    return prs.asb(index);
  }

  int asr(int index) {
    return prs.asr(index);
  }

  int nasb(int index) {
    return prs.nasb(index);
  }

  int nasr(int index) {
    return prs.nasr(index);
  }

  int terminalIndex(int index) {
    return prs.terminalIndex(index);
  }

  int nonterminalIndex(int index) {
    return prs.nonterminalIndex(index);
  }

  int symbolIndex(int index) {
    return index > NT_OFFSET
        ? nonterminalIndex(index - NT_OFFSET)
        : terminalIndex(index);
  }

  int scopePrefix(int index) {
    return prs.scopePrefix(index);
  }

  int scopeSuffix(int index) {
    return prs.scopeSuffix(index);
  }

  int scopeLhs(int index) {
    return prs.scopeLhs(index);
  }

  int scopeLa(int index) {
    return prs.scopeLa(index);
  }

  int scopeStateSet(int index) {
    return prs.scopeStateSet(index);
  }

  int scopeRhs(int index) {
    return prs.scopeRhs(index);
  }

  int scopeState(int index) {
    return prs.scopeState(index);
  }

  int inSymb(int index) {
    return prs.inSymb(index);
  }

  String name(int index) {
    return prs.name(index);
  }

  int originalState(int state) {
    return prs.originalState(state);
  }

  int asi(int state) {
    return prs.asi(state);
  }

  int nasi(int state) {
    return prs.nasi(state);
  }

  int inSymbol(int state) {
    return prs.inSymbol(state);
  }

  int ntAction(int state, int sym) {
    return prs.ntAction(state, sym);
  }

  bool isNullable(int symbol) {
    return prs.isNullable(symbol);
  }

  int stateStackTop = -1;
  List<int> stateStack = [];

  List<int> locationStack = [];

  int tempStackTop = -1;
  List<int> tempStack = [];

  int prevStackTop = -1;
  List<int> prevStack = [];

  int nextStackTop = -1;
  List<int> nextStack = [];

  int scopeStackTop = -1;
  List<int> scopeIndex = [];
  List<int> scopePosition = [];

  List<int> buffer = List.filled(BUFF_SIZE, 0);
  late ConfigurationStack main_configuration_stack;

  static final int NIL = -1;
  List<int> stateSeen = [];

  int statePoolTop = -1;
  List<StateInfo?> statePool = [];

  void reallocateStacks() {
    var old_stack_length = (stateStack.isEmpty ? 0 : stateStack.length),
        stack_length = old_stack_length + STACK_INCREMENT;

    if (stateStack.isEmpty) {
      stateStack = List.filled(stack_length, 0);
      locationStack = List.filled(stack_length, 0);
      tempStack = List.filled(stack_length, 0);
      prevStack = List.filled(stack_length, 0);
      nextStack = List.filled(stack_length, 0);
      scopeIndex = List.filled(stack_length, 0);
      scopePosition = List.filled(stack_length, 0);
    } else {
      ArrayList.copy(stateStack, 0, stateStack = List.filled(stack_length, 0),
          0, old_stack_length);
      ArrayList.copy(locationStack, 0,
          locationStack = List.filled(stack_length, 0), 0, old_stack_length);

      ArrayList.copy(tempStack, 0, tempStack = List.filled(stack_length, 0), 0,
          old_stack_length);
      ArrayList.copy(prevStack, 0, prevStack = List.filled(stack_length, 0), 0,
          old_stack_length);
      ArrayList.copy(nextStack, 0, nextStack = List.filled(stack_length, 0), 0,
          old_stack_length);
      ArrayList.copy(scopeIndex, 0, scopeIndex = List.filled(stack_length, 0),
          0, old_stack_length);
      ArrayList.copy(scopePosition, 0,
          scopePosition = List.filled(stack_length, 0), 0, old_stack_length);
    }
    return;
  }

  void diagnose([int error_token = 0]) {
    diagnoseEntry(0, error_token);
  }

  void diagnoseEntry(int marker_kind, [int? error_token]) {
    if (null != error_token) {
      diagnoseEntry2(marker_kind, error_token);
    } else {
      diagnoseEntry1(marker_kind);
    }
  }

  //
  //
  //
  void diagnoseEntry1(int marker_kind) {
    reallocateStacks();
    tempStackTop = 0;
    tempStack[tempStackTop] = START_STATE;
    tokStream.reset();
    int current_token, current_kind;
    if (marker_kind == 0) {
      current_token = tokStream.getToken();
      current_kind = tokStream.getKind(current_token);
    } else {
      current_token = tokStream.peek();
      current_kind = marker_kind;
    }

    var error_token = parseForError(current_kind);

    //
    // If an error was found, start the diagnosis and recovery.
    //
    if (error_token != 0) diagnoseEntry(marker_kind, error_token);

    return;
  }

  static int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void diagnoseEntry2(int marker_kind, int error_token) {
    var action = IntTuple(1 << 18);
    var startTime = currentTimeMillis();
    var errorCount = 0;

    //
    // Compute sequence of actions that leads us to the
    // error_token.
    //
    if (stateStack.isEmpty) {
      reallocateStacks();
    }
    tempStackTop = 0;
    tempStack[tempStackTop] = START_STATE;
    tokStream.reset();
    int current_token, current_kind;
    if (marker_kind == 0) {
      current_token = tokStream.getToken();
      current_kind = tokStream.getKind(current_token);
    } else {
      current_token = tokStream.peek();
      current_kind = marker_kind;
    }

    parseUpToError(action, current_kind, error_token);

    //
    // Start parsing
    //
    stateStackTop = 0;
    stateStack[stateStackTop] = START_STATE;

    tempStackTop = stateStackTop;
    ArrayList.copy(tempStack, 0, stateStack, 0, tempStackTop + 1);

    tokStream.reset();
    if (marker_kind == 0) {
      current_token = tokStream.getToken();
      current_kind = tokStream.getKind(current_token);
    } else {
      current_token = tokStream.peek();
      current_kind = marker_kind;
    }
    locationStack[stateStackTop] = current_token;

    //
    // Process a terminal
    //
    int act;
    do {
      //
      // Synchronize state stacks and update the location stack
      //
      var prev_pos = -1;
      prevStackTop = -1;

      var next_pos = -1;
      nextStackTop = -1;

      var pos = stateStackTop;
      tempStackTop = stateStackTop - 1;
      ArrayList.copy(stateStack, 0, tempStack, 0, stateStackTop + 1);

      var action_index = 0;
      act = action.get(action_index++); // tAction(act, current_kind);

      //
      // When a reduce action is encountered, we compute all REDUCE
      // and associated goto actions induced by the current token.
      // Eventually, a SHIFT, SHIFT-REDUCE, ACCEPT or ERROR action is
      // computed...
      //
      while (act <= NUM_RULES) {
        do {
          tempStackTop -= (rhs(act) - 1);
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
        //
        // ... Update the maximum useful position of the
        // (STATE_)STACK, push goto state into stack, and
        // compute next action on current symbol ...
        //
        if (tempStackTop + 1 >= stateStack.length) reallocateStacks();
        pos = pos < tempStackTop ? pos : tempStackTop;
        tempStack[tempStackTop + 1] = act;
        act = action.get(action_index++); // tAction(act, current_kind);
      }

      //
      // At this point, we have a shift, shift-reduce, accept or error
      // action.  STACK contains the configuration of the state stack
      // prior to executing any action on current_token. next_stack contains
      // the configuration of the state stack after executing all
      // reduce actions induced by current_token.  The variable pos indicates
      // the highest position in STACK that is still useful after the
      // reductions are executed.
      //
      while (act > ERROR_ACTION ||
          act < ACCEPT_ACTION) // SHIFT-REDUCE action or SHIFT action ?
      {
        //
        // if the parser needs to stop processing,
        // it may do so here.
        //
        if (monitor != null && monitor!.isCancelled()) {
          return;
        }

        nextStackTop = tempStackTop + 1;
        for (var i = next_pos + 1; i <= nextStackTop; i++) {
          nextStack[i] = tempStack[i];
        }

        for (var k = pos + 1; k <= nextStackTop; k++) {
          locationStack[k] = locationStack[stateStackTop];
        }

        //
        // If we have a shift-reduce, process it as well as
        // the goto-reduce actions that follow it.
        //
        if (act > ERROR_ACTION) {
          act -= ERROR_ACTION;
          do {
            nextStackTop -= (rhs(act) - 1);
            act = ntAction(nextStack[nextStackTop], lhs(act));
          } while (act <= NUM_RULES);
          pos = pos < nextStackTop ? pos : nextStackTop;
        }

        if (nextStackTop + 1 >= stateStack.length) reallocateStacks();

        tempStackTop = nextStackTop;
        nextStack[++nextStackTop] = act;
        next_pos = nextStackTop;

        //
        // Simulate the parser through the next token without
        // destroying STACK or next_stack.
        //
        current_token = tokStream.getToken();
        current_kind = tokStream.getKind(current_token);
        act = action.get(action_index++); // tAction(act, current_kind);
        while (act <= NUM_RULES) {
          //
          // ... Process all goto-reduce actions following
          // reduction, until a goto action is computed ...
          //
          do {
            var lhs_symbol = lhs(act);
            tempStackTop -= (rhs(act) - 1);
            act = (tempStackTop > next_pos
                ? tempStack[tempStackTop]
                : nextStack[tempStackTop]);
            act = ntAction(act, lhs_symbol);
          } while (act <= NUM_RULES);

          //
          // ... Update the maximum useful position of the
          // (STATE_)STACK, push GOTO state into stack, and
          // compute next action on current symbol ...
          //
          if (tempStackTop + 1 >= stateStack.length) reallocateStacks();

          next_pos = next_pos < tempStackTop ? next_pos : tempStackTop;
          tempStack[tempStackTop + 1] = act;
          act = action.get(action_index++); // tAction(act, current_kind);
        }

        //
        // No error was detected, Read next token into
        // PREVTOK element, advance CURRENT_TOKEN pointer and
        // update stacks.
        //
        if (act != ERROR_ACTION) {
          prevStackTop = stateStackTop;
          for (var i = prev_pos + 1; i <= prevStackTop; i++) {
            prevStack[i] = stateStack[i];
          }
          prev_pos = pos;

          stateStackTop = nextStackTop;
          for (var k = pos + 1; k <= stateStackTop; k++) {
            stateStack[k] = nextStack[k];
          }
          locationStack[stateStackTop] = current_token;
          pos = next_pos;
        }
      }

      //
      // At this stage, either we have an ACCEPT or an ERROR
      // action.
      //
      if (act == ERROR_ACTION) {
        //
        // An error was detected.
        //
        errorCount += 1;

        //
        // Check time and error limits after the first error encountered
        // Exit if number of errors exceeds maxError or if maxTime reached
        //
        if (errorCount > 1) {
          if (maxErrors > 0 && errorCount > maxErrors) break;
          if (maxTime > 0 && currentTimeMillis() - startTime > maxTime) break;
        }

        var candidate = errorRecovery(current_token);

        //
        // if the parser needs to stop processing,
        // it may do so here.
        //
        if (monitor != null && monitor!.isCancelled()) return;

        act = stateStack[stateStackTop];

        //
        // If the recovery was successful on a nonterminal candidate,
        // parse through that candidate and "read" the next token.
        //
        if (candidate.symbol == 0) {
          break;
        } else if (candidate.symbol > NT_OFFSET) {
          var lhs_symbol = candidate.symbol - NT_OFFSET;
          act = ntAction(act, lhs_symbol);
          while (act <= NUM_RULES) {
            stateStackTop -= (rhs(act) - 1);
            act = ntAction(stateStack[stateStackTop], lhs(act));
          }
          stateStack[++stateStackTop] = act;
          current_token = tokStream.getToken();
          current_kind = tokStream.getKind(current_token);
          locationStack[stateStackTop] = current_token;
        } else {
          current_kind = candidate.symbol;
          locationStack[stateStackTop] = candidate.location;
        }

        //
        // At this stage, we have a recovery configuration. See how
        // far we can go with it.
        //
        var next_token = tokStream.peek();
        tempStackTop = stateStackTop;
        ArrayList.copy(stateStack, 0, tempStack, 0, stateStackTop + 1);
        error_token = parseForError(current_kind);

        //
        // If an error was found, compute the sequence of actions that reaches
        // the error token. Otherwise, claim victory...
        //
        if (error_token != 0) {
          tokStream.reset(next_token);
          tempStackTop = stateStackTop;
          ArrayList.copy(stateStack, 0, tempStack, 0, stateStackTop + 1);
          parseUpToError(action, current_kind, error_token);
          tokStream.reset(next_token);
        } else {
          act = ACCEPT_ACTION;
        }
      }
    } while (act != ACCEPT_ACTION);

    return;
  }

  //
  // Given the configuration consisting of the states in tempStack
  // and the sequence of tokens (current_kind, followed by the tokens
  // in tokStream), keep parsing until either the parse completes
  // successfully or it encounters an error. If the parse is not
  // succesful, we return the farthest token on which an error was
  // encountered. Otherwise, we return 0.
  //
  int parseForError(int current_kind) {
    var error_token = 0;

    //
    // Get next token in stream and compute initial action
    //
    var curtok = tokStream.getPrevious(tokStream.peek()),
        act = tAction(tempStack[tempStackTop], current_kind);

    //
    // Allocate configuration stack.
    //
    var configuration_stack = ConfigurationStack(prs);

    //
    // Keep parsing until we reach the end of file and succeed or
    // an error is encountered. The list of actions executed will
    // be store in the "action" tuple.
    //
    for (;;) {
      if (act <= NUM_RULES) {
        tempStackTop--;

        do {
          tempStackTop -= (rhs(act) - 1);
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act > ERROR_ACTION) {
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        act -= ERROR_ACTION;

        do {
          tempStackTop -= (rhs(act) - 1);
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act < ACCEPT_ACTION) {
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
      } else if (act == ERROR_ACTION) {
        error_token = (error_token > curtok ? error_token : curtok);

        var configuration = configuration_stack.pop();
        if (configuration == null) {
          act = ERROR_ACTION;
        } else {
          tempStackTop = configuration.stack_top;
          configuration.retrieveStack(tempStack);
          act = configuration.act;
          curtok = configuration.curtok;
          // no need to execute: action.reset(configuration.action_length);
          current_kind = tokStream.getKind(curtok);
          tokStream.reset(tokStream.getNext(curtok));
          continue;
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            tempStack, tempStackTop, curtok)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(tempStack, tempStackTop, act + 1, curtok, 0);
          act = baseAction(act);
        }
        continue;
      } else {
        break;
      } // assert(act == ACCEPT_ACTION);

      try {
        tempStack[++tempStackTop] = act;
      } on RangeError {
        reallocateStacks();
        tempStack[tempStackTop] = act;
      }
      act = tAction(act, current_kind);
    }

    return (act == ERROR_ACTION ? error_token : 0);
  }

  //
  // Given the configuration consisting of the states in tempStack
  // and the sequence of tokens (current_kind, followed by the tokens
  // in tokStream), parse up to error_token in the tokStream and store
  // all the parsing actions executed in the "action" tuple.
  //
  void parseUpToError(IntTuple action, int current_kind, int error_token) {
    //
    // Assume predecessor of next token and compute initial action
    //
    var curtok = tokStream.getPrevious(tokStream.peek());
    var act = tAction(tempStack[tempStackTop], current_kind);

    //
    // Allocate configuration stack.
    //
    var configuration_stack = ConfigurationStack(prs);

    //
    // Keep parsing until we reach the end of file and succeed or
    // an error is encountered. The list of actions executed will
    // be store in the "action" tuple.
    //
    action.reset();
    for (;;) {
      if (act <= NUM_RULES) {
        action.add(act); // save this reduce action
        tempStackTop--;

        do {
          tempStackTop -= (rhs(act) - 1);
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act > ERROR_ACTION) {
        action.add(act); // save this shift-reduce action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        act -= ERROR_ACTION;

        do {
          tempStackTop -= (rhs(act) - 1);
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act < ACCEPT_ACTION) {
        action.add(act); // save this shift action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
      } else if (act == ERROR_ACTION) {
        if (curtok != error_token) {
          var configuration = configuration_stack.pop();
          if (configuration == null) {
            act = ERROR_ACTION;
          } else {
            tempStackTop = configuration.stack_top;
            configuration.retrieveStack(tempStack);
            act = configuration.act;
            curtok = configuration.curtok;
            action.reset(configuration.action_length);
            current_kind = tokStream.getKind(curtok);
            tokStream.reset(tokStream.getNext(curtok));
            continue;
          }
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            tempStack, tempStackTop, curtok)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(
              tempStack, tempStackTop, act + 1, curtok, action.size());
          act = baseAction(act);
        }
        continue;
      } else {
        break;
      } // assert(act == ACCEPT_ACTION);

      try {
        tempStack[++tempStackTop] = act;
      } on RangeError {
        reallocateStacks();
        tempStack[tempStackTop] = act;
      }
      act = tAction(act, current_kind);
    }

    action.add(ERROR_ACTION);

    return;
  }

  //
  // Try to parse until first_symbol and all tokens in BUFFER have
  // been consumed, or an error is encountered. Return the number
  // of tokens that were expended before the parse blocked.
  //
  int parseCheck(
      List<int> stack, int stack_top, int first_symbol, int buffer_position) {
    int buffer_index, current_kind;

    var local_stack = List<int>.filled(stack.length, 0);
    var local_stack_top = stack_top;
    for (var i = 0; i <= stack_top; i++) {
      local_stack[i] = stack[i];
    }

    var configuration_stack = ConfigurationStack(prs);

    //
    // If the first symbol is a nonterminal, process it here.
    //
    var act = local_stack[local_stack_top];
    if (first_symbol > NT_OFFSET) {
      var lhs_symbol = first_symbol - NT_OFFSET;
      buffer_index = buffer_position;
      current_kind = tokStream.getKind(buffer[buffer_index]);
      tokStream.reset(tokStream.getNext(buffer[buffer_index]));
      act = ntAction(act, lhs_symbol);
      while (act <= NUM_RULES) {
        local_stack_top -= (rhs(act) - 1);
        act = ntAction(local_stack[local_stack_top], lhs(act));
      }
    } else {
      local_stack_top--;
      buffer_index = buffer_position - 1;
      current_kind = first_symbol;
      tokStream.reset(buffer[buffer_position]);
    }

    //
    // Start parsing the remaining symbols in the buffer
    //
    if (++local_stack_top >= local_stack.length) {
      return buffer_index;
    }
    local_stack[local_stack_top] = act;

    act = tAction(act, current_kind);

    for (;;) {
      if (act <= NUM_RULES) // reduce action
      {
        local_stack_top -= rhs(act);
        act = ntAction(local_stack[local_stack_top], lhs(act));

        while (act <= NUM_RULES) {
          local_stack_top -= (rhs(act) - 1);
          act = ntAction(local_stack[local_stack_top], lhs(act));
        }
      } else if (act > ERROR_ACTION) // shift-reduce action
      {
        if (buffer_index++ == MAX_DISTANCE) break;
        current_kind = tokStream.getKind(buffer[buffer_index]);
        tokStream.reset(tokStream.getNext(buffer[buffer_index]));
        act -= ERROR_ACTION;

        do {
          local_stack_top -= (rhs(act) - 1);
          act = ntAction(local_stack[local_stack_top], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act < ACCEPT_ACTION) // shift action
      {
        if (buffer_index++ == MAX_DISTANCE) break;
        current_kind = tokStream.getKind(buffer[buffer_index]);
        tokStream.reset(tokStream.getNext(buffer[buffer_index]));
      } else if (act == ERROR_ACTION) {
        var configuration = configuration_stack.pop();
        if (configuration == null) {
          act = ERROR_ACTION;
        } else {
          local_stack_top = configuration.stack_top;
          configuration.retrieveStack(local_stack);
          act = configuration.act;
          buffer_index = configuration.curtok;
          // no need to execute: action.reset(configuration.action_length);
          current_kind = tokStream.getKind(buffer[buffer_index]);
          tokStream.reset(tokStream.getNext(buffer[buffer_index]));
          continue;
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            local_stack, local_stack_top, buffer_index)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(
              local_stack, local_stack_top, act + 1, buffer_index, 0);
          act = baseAction(act);
        }
        continue;
      } else {
        break;
      }

      if (++local_stack_top >= local_stack.length) {
        break; // Stack overflow!!!
      }
      local_stack[local_stack_top] = act;

      act = tAction(act, current_kind);
    }

    return (act == ACCEPT_ACTION ? MAX_DISTANCE : buffer_index);
  }

  //
  //  This routine is invoked when an error is encountered.  It
  // tries to diagnose the error and recover from it.  If it is
  // successful, the state stack, the current token and the buffer
  // are readjusted; i.e., after a successful recovery,
  // state_stack_top points to the location in the state stack
  // that contains the state on which to recover; current_token
  // identifies the symbol on which to recover.
  //
  // Up to three configurations may be available when this routine
  // is invoked. PREV_STACK may contain the sequence of states
  // preceding any action on prevtok, STACK always contains the
  // sequence of states preceding any action on current_token, and
  // NEXT_STACK may contain the sequence of states preceding any
  // action on the successor of current_token.
  //
  RepairCandidate errorRecovery(int error_token) {
    var prevtok = tokStream.getPrevious(error_token);

    //
    // Try primary phase recoveries. If not successful, try secondary
    // phase recoveries.  If not successful and we are at end of the
    // file, we issue the end-of-file error and quit. Otherwise, ...
    //
    var candidate = primaryPhase(error_token);
    if (candidate.symbol != 0) return candidate;

    candidate = secondaryPhase(error_token);
    if (candidate.symbol != 0) return candidate;

    //
    // At this point, primary and (initial attempt at) secondary
    // recovery did not work.  We will now get into "panic mode" and
    // keep trying secondary phase recoveries until we either find
    // a successful recovery or have consumed the remaining input
    // tokens.
    //
    if (tokStream.getKind(error_token) != EOFT_SYMBOL) {
      while (tokStream.getKind(buffer[BUFF_UBOUND]) != EOFT_SYMBOL) {
        candidate = secondaryPhase(buffer[MAX_DISTANCE - MIN_DISTANCE + 2]);
        if (candidate.symbol != 0) return candidate;
      }
    }

    //
    // If no successful recovery is found and we have reached the
    // end of the file, check whether or not any scope recovery is
    // applicable at the end of the file after discarding some
    // states.
    //
    var scope_repair = PrimaryRepairInfo();
    scope_repair.bufferPosition = BUFF_UBOUND;
    for (var top = stateStackTop; top >= 0; top--) {
      scopeTrial(scope_repair, stateStack, top);

      if (scope_repair.distance > 0) break;
    }

    //
    // If any scope repair was successful, emit the message now
    //
    for (var i = 0; i < scopeStackTop; i++) {
      emitError(SCOPE_CODE, -scopeIndex[i], locationStack[scopePosition[i]],
          buffer[1], nonterminalIndex(scopeLhs(scopeIndex[i])));
    }

    //
    // If the original error_token was already pointing to the EOF, issue the EOF-reached message.
    //
    if (tokStream.getKind(error_token) == EOFT_SYMBOL) {
      emitError(EOF_CODE, terminalIndex(EOFT_SYMBOL), prevtok, prevtok);
    } else {
      //
      // We reached the end of the file while panicking. Delete all
      // remaining tokens in the input.
      //
      var i = 0;
      for (i = BUFF_UBOUND; tokStream.getKind(buffer[i]) == EOFT_SYMBOL; i--) {
        ;
      }

      emitError(DELETION_CODE, terminalIndex(tokStream.getKind(error_token)),
          error_token, buffer[i]);
    }

    //
    // Create the "failed" candidate and return it.
    //
    candidate.symbol = 0;
    candidate.location = buffer[BUFF_UBOUND]; // point to EOF

    return candidate;
  }

  //
  // This function tries primary and scope recovery on each
  // available configuration.  If a successful recovery is found
  // and no secondary phase recovery can do better, a diagnosis is
  // issued, the configuration is updated and the function returns
  // "true".  Otherwise, it returns "false".
  //
  RepairCandidate primaryPhase(int error_token) {
    //
    // Initialize the buffer.
    //
    var i = (nextStackTop >= 0 ? 3 : 2);
    buffer[i] = error_token;

    for (var j = i; j > 0; j--) {
      buffer[j - 1] = tokStream.getPrevious(buffer[j]);
    }

    for (var k = i + 1; k < BUFF_SIZE; k++) {
      buffer[k] = tokStream.getNext(buffer[k - 1]);
    }

    //
    // If NEXT_STACK_TOP > 0 then the parse was successful on CURRENT_TOKEN
    // and the error was detected on the successor of CURRENT_TOKEN. In
    // that case, first check whether or not primary recovery is
    // possible on next_stack ...
    //
    var repair = PrimaryRepairInfo();
    if (nextStackTop >= 0) {
      repair.bufferPosition = 3;
      checkPrimaryDistance(repair, nextStack, nextStackTop);
    }

    //
    // ... Try primary recovery on the current token and compare
    // the quality of this recovery to the one on the next token...
    //
    var base_repair = PrimaryRepairInfo(repair);
    base_repair.bufferPosition = 2;
    checkPrimaryDistance(base_repair, stateStack, stateStackTop);
    if (base_repair.distance > repair.distance ||
        base_repair.misspellIndex > repair.misspellIndex) repair = base_repair;

    //
    // Finally, if prev_stack_top >= 0 try primary recovery on
    // the prev_stack configuration and compare it to the best
    // recovery computed thus far.
    //
    if (prevStackTop >= 0) {
      var prev_repair = PrimaryRepairInfo(repair);
      prev_repair.bufferPosition = 1;
      checkPrimaryDistance(prev_repair, prevStack, prevStackTop);
      if (prev_repair.distance > repair.distance ||
          prev_repair.misspellIndex > repair.misspellIndex) {
        repair = prev_repair;
      }
    }

    //
    // Before accepting the best primary phase recovery obtained,
    // ensure that we cannot do better with a similar secondary
    // phase recovery.
    //
    var candidate = RepairCandidate();
    if (nextStackTop >= 0) // next_stack available
    {
      if (secondaryCheck(nextStack, nextStackTop, 3, repair.distance)) {
        return candidate;
      }
    } else if (secondaryCheck(stateStack, stateStackTop, 2, repair.distance)) {
      return candidate;
    }

    //
    // First, adjust distance if the recovery is on the error token;
    // it is important that the adjustment be made here and not at
    // each primary trial to prevent the distance tests from being
    // biased in favor of deferred recoveries which have access to
    // more input tokens...
    //
    repair.distance = repair.distance - repair.bufferPosition + 1;

    //
    // ...Next, adjust the distance if the recovery is a deletion or
    // (some form of) substitution...
    //
    if (repair.code == INVALID_CODE ||
        repair.code == DELETION_CODE ||
        repair.code == SUBSTITUTION_CODE ||
        repair.code == MERGE_CODE) repair.distance--;

    //
    // ... After adjustment, check if the most successful primary
    // recovery can be applied.  If not, continue with more radical
    // recoveries...
    //
    if (repair.distance < MIN_DISTANCE) return candidate;

    //
    // When processing an insertion error, if the token preceeding
    // the error token is not available, we change the repair code
    // into a BEFORE_CODE to instruct the reporting routine that it
    // indicates that the repair symbol should be inserted before
    // the error token.
    //
    if (repair.code == INSERTION_CODE) {
      if (tokStream.getKind(buffer[repair.bufferPosition - 1]) == 0) {
        repair.code = BEFORE_CODE;
      }
    }

    //
    // Select the proper sequence of states on which to recover,
    // update stack accordingly and call diagnostic routine.
    //
    if (repair.bufferPosition == 1) {
      stateStackTop = prevStackTop;
      ArrayList.copy(prevStack, 0, stateStack, 0, stateStackTop + 1);
    } else if (nextStackTop >= 0 && repair.bufferPosition >= 3) {
      stateStackTop = nextStackTop;
      ArrayList.copy(nextStack, 0, stateStack, 0, stateStackTop + 1);
      locationStack[stateStackTop] = buffer[3];
    }

    return primaryDiagnosis(repair);
  }

  //
  //  This function checks whether or not a given state has a
  // candidate, whose string representaion is a merging of the two
  // tokens at positions buffer_position and buffer_position+1 in
  // the buffer.  If so, it returns the candidate in question;
  // otherwise it returns 0.
  //
  int mergeCandidate(int state, int buffer_position) {
    var str = tokStream.getName(buffer[buffer_position]) +
        tokStream.getName(buffer[buffer_position + 1]);
    for (var k = asi(state); asr(k) != 0; k++) {
      var i = terminalIndex(asr(k));
      if (str.length == name(i).length) {
        if (str.toLowerCase() == (name(i).toLowerCase())) return asr(k);
      }
    }

    return 0;
  }

  //
  // This procedure takes as arguments a parsing configuration
  // consisting of a state stack (stack and stack_top) and a fixed
  // number of input tokens (starting at buffer_position) in the
  // input BUFFER; and some reference arguments: repair_code,
  // distance, misspell_index, candidate, and stack_position
  // which it sets based on the best possible recovery that it
  // finds in the given configuration.  The effectiveness of a
  // a repair is judged based on two criteria:
  //
  //       1) the number of tokens that can be parsed after the repair
  //              is applied: distance.
  //       2) how close to perfection is the candidate that is chosen:
  //              misspell_index.
  //
  // When this procedure is entered, distance, misspell_index and
  // repair_code are assumed to be initialized.
  //
  void checkPrimaryDistance(
      PrimaryRepairInfo repair, List<int> stck, int stack_top) {
    //
    //  First, try scope recovery.
    //
    var scope_repair = PrimaryRepairInfo(repair);
    scopeTrial(scope_repair, stck, stack_top);
    if (scope_repair.distance > repair.distance) repair.copy(scope_repair);

    //
    //  Next, try merging the error token with its successor.
    //
    var symbol = mergeCandidate(stck[stack_top], repair.bufferPosition);
    if (symbol != 0) {
      var j = parseCheck(stck, stack_top, symbol, repair.bufferPosition + 2);
      if ((j > repair.distance) ||
          (j == repair.distance && repair.misspellIndex < 10)) {
        repair.misspellIndex = 10;
        repair.symbol = symbol;
        repair.distance = j;
        repair.code = MERGE_CODE;
      }
    }

    //
    // Next, try deletion of the error token.
    //
    var j = parseCheck(
        stck,
        stack_top,
        tokStream.getKind(buffer[repair.bufferPosition + 1]),
        repair.bufferPosition + 2);
    var k = (tokStream.getKind(buffer[repair.bufferPosition]) == EOLT_SYMBOL &&
            tokStream.afterEol(buffer[repair.bufferPosition + 1])
        ? 10
        : 0);
    if (j > repair.distance ||
        (j == repair.distance && k > repair.misspellIndex)) {
      repair.misspellIndex = k;
      repair.code = DELETION_CODE;
      repair.distance = j;
    }

    //
    // Update the error configuration by simulating all reduce and
    // goto actions induced by the error token. Then assign the top
    // most state of the new configuration to next_state.
    //
    var next_state = stck[stack_top], max_pos = stack_top;
    tempStackTop = stack_top - 1;

    tokStream.reset(buffer[repair.bufferPosition + 1]);
    var tok = tokStream.getKind(buffer[repair.bufferPosition]),
        act = tAction(next_state, tok);
    while (act <= NUM_RULES) {
      do {
        var lhs_symbol = lhs(act);
        tempStackTop -= (rhs(act) - 1);
        act = (tempStackTop > max_pos
            ? tempStack[tempStackTop]
            : stck[tempStackTop]);
        act = ntAction(act, lhs_symbol);
      } while (act <= NUM_RULES);
      max_pos = max_pos < tempStackTop ? max_pos : tempStackTop;
      tempStack[tempStackTop + 1] = act;
      next_state = act;
      act = tAction(next_state, tok);
    }

    //
    //  Next, place the list of candidates in proper order.
    //
    var root = 0;
    for (var i = asi(next_state); asr(i) != 0; i++) {
      symbol = asr(i);
      if (symbol != EOFT_SYMBOL && symbol != ERROR_SYMBOL) {
        if (root == 0) {
          list[symbol] = symbol;
        } else {
          list[symbol] = list[root];
          list[root] = symbol;
        }
        root = symbol;
      }
    }

    if (stck[stack_top] != next_state) {
      for (var i = asi(stck[stack_top]); asr(i) != 0; i++) {
        symbol = asr(i);
        if (symbol != EOFT_SYMBOL &&
            symbol != ERROR_SYMBOL &&
            list[symbol] == 0) {
          if (root == 0) {
            list[symbol] = symbol;
          } else {
            list[symbol] = list[root];
            list[root] = symbol;
          }
          root = symbol;
        }
      }
    }

    var head = list[root];
    list[root] = 0;
    root = head;

    //
    //  Next, try insertion for each possible candidate available in
    // the current state, except EOFT and ERROR_SYMBOL.
    //
    symbol = root;
    while (symbol != 0) {
      var m = parseCheck(stck, stack_top, symbol, repair.bufferPosition),
          n = (symbol == EOLT_SYMBOL &&
                  tokStream.afterEol(buffer[repair.bufferPosition])
              ? 10
              : 0);
      if (m > repair.distance ||
          (m == repair.distance && n > repair.misspellIndex)) {
        repair.misspellIndex = n;
        repair.distance = m;
        repair.symbol = symbol;
        repair.code = INSERTION_CODE;
      }

      symbol = list[symbol];
    }

    //
    //  Next, Try substitution for each possible candidate available
    // in the current state, except EOFT and ERROR_SYMBOL.
    //
    symbol = root;
    while (symbol != 0) {
      var m = parseCheck(stck, stack_top, symbol, repair.bufferPosition + 1),
          n = (symbol == EOLT_SYMBOL &&
                  tokStream.afterEol(buffer[repair.bufferPosition + 1])
              ? 10
              : misspell(symbol, buffer[repair.bufferPosition]));
      if (m > repair.distance ||
          (m == repair.distance && n > repair.misspellIndex)) {
        repair.misspellIndex = n;
        repair.distance = m;
        repair.symbol = symbol;
        repair.code = SUBSTITUTION_CODE;
      }

      var s = symbol;
      symbol = list[symbol];
      list[s] = 0; // reset element
    }

    //
    // Next, we try to insert a nonterminal candidate in front of the
    // error token, or substituting a nonterminal candidate for the
    // error token. Precedence is given to insertion.
    //
    for (var nt_index = nasi(stck[stack_top]);
        nasr(nt_index) != 0;
        nt_index++) {
      symbol = nasr(nt_index) + NT_OFFSET;
      var n = parseCheck(stck, stack_top, symbol, repair.bufferPosition + 1);
      if (n > repair.distance) {
        repair.misspellIndex = 0;
        repair.distance = n;
        repair.symbol = symbol;
        repair.code = INVALID_CODE;
      }

      n = parseCheck(stck, stack_top, symbol, repair.bufferPosition);
      if (n > repair.distance ||
          (n == repair.distance && repair.code == INVALID_CODE)) {
        repair.misspellIndex = 0;
        repair.distance = n;
        repair.symbol = symbol;
        repair.code = INSERTION_CODE;
      }
    }

    return;
  }

  //
  // This procedure is invoked to issue a diagnostic message and
  // adjust the input buffer.  The recovery in question is either
  // the insertion of one or more scopes, the merging of the error
  // token with its successor, the deletion of the error token,
  // the insertion of a single token in front of the error token
  // or the substitution of another token for the error token.
  //
  RepairCandidate primaryDiagnosis(PrimaryRepairInfo repair) {
    //
    //  Issue diagnostic.
    //
    var prevtok = buffer[repair.bufferPosition - 1],
        current_token = buffer[repair.bufferPosition];

    switch (repair.code) {
      case INSERTION_CODE:
      case BEFORE_CODE:
        {
          var name_index = (repair.symbol > NT_OFFSET
              ? getNtermIndex(stateStack[stateStackTop], repair.symbol,
                  repair.bufferPosition)
              : getTermIndex(stateStack, stateStackTop, repair.symbol,
                  repair.bufferPosition));
          var tok = (repair.code == INSERTION_CODE ? prevtok : current_token);
          emitError(repair.code, name_index, tok, tok);
          break;
        }
      case INVALID_CODE:
        {
          var name_index = getNtermIndex(stateStack[stateStackTop],
              repair.symbol, repair.bufferPosition + 1);
          emitError(repair.code, name_index, current_token, current_token);
          break;
        }
      case SUBSTITUTION_CODE:
        {
          int name_index;
          if (repair.misspellIndex >= 6) {
            name_index = terminalIndex(repair.symbol);
          } else {
            name_index = getTermIndex(stateStack, stateStackTop, repair.symbol,
                repair.bufferPosition + 1);
            if (name_index != terminalIndex(repair.symbol)) {
              repair.code = INVALID_CODE;
            }
          }
          emitError(repair.code, name_index, current_token, current_token);
          break;
        }
      case MERGE_CODE:
        emitError(repair.code, terminalIndex(repair.symbol), current_token,
            tokStream.getNext(current_token));
        break;
      case SCOPE_CODE:
        {
          for (var i = 0; i < scopeStackTop; i++) {
            emitError(
                repair.code,
                -scopeIndex[i],
                locationStack[scopePosition[i]],
                prevtok,
                nonterminalIndex(scopeLhs(scopeIndex[i])));
          }

          repair.symbol = scopeLhs(scopeIndex[scopeStackTop]) + NT_OFFSET;
          stateStackTop = scopePosition[scopeStackTop];
          emitError(
              repair.code,
              -scopeIndex[scopeStackTop],
              locationStack[scopePosition[scopeStackTop]],
              prevtok,
              getNtermIndex(stateStack[stateStackTop], repair.symbol,
                  repair.bufferPosition));
          break;
        }
      default: // deletion
        emitError(repair.code, terminalIndex(ERROR_SYMBOL), current_token,
            current_token);
    }

    //
    //  Update buffer.
    //
    var candidate = RepairCandidate();
    switch (repair.code) {
      case INSERTION_CODE:
      case BEFORE_CODE:
      case SCOPE_CODE:
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition]);
        break;
      case INVALID_CODE:
      case SUBSTITUTION_CODE:
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition + 1]);
        break;
      case MERGE_CODE:
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition + 2]);
        break;
      default: // deletion
        candidate.location = buffer[repair.bufferPosition + 1];
        candidate.symbol = tokStream.getKind(buffer[repair.bufferPosition + 1]);
        tokStream.reset(buffer[repair.bufferPosition + 2]);
        break;
    }

    return candidate;
  }

  //
  // This function takes as parameter an integer STACK_TOP that
  // points to a STACK element containing the state on which a
  // primary recovery will be made; the terminal candidate on which
  // to recover; and an integer: buffer_position, which points to
  // the position of the next input token in the BUFFER.  The
  // parser is simulated until a shift (or shift-reduce) action
  // is computed on the candidate.  Then we proceed to compute the
  // the name index of the highest level nonterminal that can
  // directly or indirectly produce the candidate.
  //
  int getTermIndex(
      List<int> stck, int stack_top, int tok, int buffer_position) {
    //
    // Initialize stack index of temp_stack and initialize maximum
    // position of state stack that is still useful.
    //
    var act = stck[stack_top], max_pos = stack_top, highest_symbol = tok;

    tempStackTop = stack_top - 1;

    //
    // Compute all reduce and associated actions induced by the
    // candidate until a SHIFT or SHIFT-REDUCE is computed. ERROR
    // and ACCEPT actions cannot be computed on the candidate in
    // this context, since we know that it is suitable for recovery.
    //
    tokStream.reset(buffer[buffer_position]);
    act = tAction(act, tok);
    while (act <= NUM_RULES) {
      //
      // Process all goto-reduce actions following reduction,
      // until a goto action is computed ...
      //
      do {
        var lhs_symbol = lhs(act);
        tempStackTop -= (rhs(act) - 1);
        act = (tempStackTop > max_pos
            ? tempStack[tempStackTop]
            : stck[tempStackTop]);
        act = ntAction(act, lhs_symbol);
      } while (act <= NUM_RULES);

      //
      // Compute new maximum useful position of (STATE_)stack,
      // push goto state into the stack, and compute next
      // action on candidate ...
      //
      max_pos = max_pos < tempStackTop ? max_pos : tempStackTop;
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }

    //
    // At this stage, we have simulated all actions induced by the
    // candidate and we are ready to shift or shift-reduce it. First,
    // set tok and next_ptr appropriately and identify the candidate
    // as the initial highest_symbol. If a shift action was computed
    // on the candidate, update the stack and compute the next
    // action. Next, simulate all actions possible on the next input
    // token until we either have to shift it or are about to reduce
    // below the initial starting point in the stack (indicated by
    // max_pos as computed in the previous loop).  At that point,
    // return the highest_symbol computed.
    //
    tempStackTop++; // adjust top of stack to reflect last goto
    // next move is shift or shift-reduce.
    var threshold = tempStackTop;

    tok = tokStream.getKind(buffer[buffer_position]);
    tokStream.reset(buffer[buffer_position + 1]);

    if (act > ERROR_ACTION) {
      act -= ERROR_ACTION;
    } else if (act < ACCEPT_ACTION) // shift on candidate
    {
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }

    while (act <= NUM_RULES) {
      //
      // Process all goto-reduce actions following reduction,
      // until a goto action is computed ...
      //
      do {
        var lhs_symbol = lhs(act);
        tempStackTop -= (rhs(act) - 1);

        if (tempStackTop < threshold) {
          return (highest_symbol > NT_OFFSET
              ? nonterminalIndex(highest_symbol - NT_OFFSET)
              : terminalIndex(highest_symbol));
        }

        if (tempStackTop == threshold) highest_symbol = lhs_symbol + NT_OFFSET;
        act = (tempStackTop > max_pos
            ? tempStack[tempStackTop]
            : stck[tempStackTop]);
        act = ntAction(act, lhs_symbol);
      } while (act <= NUM_RULES);

      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }

    return (highest_symbol > NT_OFFSET
        ? nonterminalIndex(highest_symbol - NT_OFFSET)
        : terminalIndex(highest_symbol));
  }

  //
  // This function takes as parameter a starting state number:
  // start, a nonterminal symbol, A (candidate), and an integer,
  // buffer_position,  which points to the position of the next
  // input token in the BUFFER.
  // It returns the highest level non-terminal B such that
  // B =>*rm A.  I.e., there does not exists a nonterminal C such
  // that C =>+rm B. (Recall that for an LALR(k) grammar if
  // C =>+rm B, it cannot be the case that B =>+rm C)
  //
  int getNtermIndex(int start, int sym, int buffer_position) {
    var highest_symbol = sym - NT_OFFSET,
        tok = tokStream.getKind(buffer[buffer_position]);
    tokStream.reset(buffer[buffer_position + 1]);

    //
    // Initialize stack index of temp_stack and initialize maximum
    // position of state stack that is still useful.
    //
    tempStackTop = 0;
    tempStack[tempStackTop] = start;

    var act = ntAction(start, highest_symbol);
    if (act > NUM_RULES) // goto action?
    {
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }

    while (act <= NUM_RULES) {
      //
      // Process all goto-reduce actions following reduction,
      // until a goto action is computed ...
      //
      do {
        tempStackTop -= (rhs(act) - 1);
        if (tempStackTop < 0) return nonterminalIndex(highest_symbol);
        if (tempStackTop == 0) highest_symbol = lhs(act);
        act = ntAction(tempStack[tempStackTop], lhs(act));
      } while (act <= NUM_RULES);
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }

    return nonterminalIndex(highest_symbol);
  }

  //
  //  Check whether or not there is a high probability that a
  // given string is a misspelling of another.
  // Certain singleton symbols (such as ":" and ";") are also
  // considered to be misspellings of each other.
  //
  int misspell(int sym, int tok) {
    //
    // Set up the two strings in question. Note that there is a "0"
    // gate added at the end of each string. This is important as
    // the algorithm assumes that it can "peek" at the symbol immediately
    // following the one that is being analysed.
    //
    var s1 = name(terminalIndex(sym)).toLowerCase();
    var n = s1.length;
    s1 += '\u0000';

    var s2 = (tokStream.getName(tok)).toLowerCase();
    var m = (s2.length < MAX_NAME_LENGTH ? s2.length : MAX_NAME_LENGTH);
    s2 = s2.substring(0, m) + '\u0000';

    //
    //  Singleton misspellings:
    //
    //  ;      <---->     ,
    //
    //  ;      <---->     :
    //
    //  .      <---->     ,
    //
    //  '      <---->     "
    //
    //
    if (n == 1 && m == 1) {
      if ((s1[0] == ';' && s2[0] == ',') ||
          (s1[0] == ',' && s2[0] == ';') ||
          (s1[0] == ';' && s2[0] == ':') ||
          (s1[0] == ':' && s2[0] == ';') ||
          (s1[0] == '.' && s2[0] == ',') ||
          (s1[0] == ',' && s2[0] == '.') ||
          (s1[0] == '\'' && s2[0] == '\"') ||
          (s1[0] == '\"' && s2[0] == '\'')) {
        return 3;
      }
    }

    //
    // Scan the two strings. Increment "match" count for each match.
    // When a transposition is encountered, increase "match" count
    // by two but count it as one error. When a typo is found, skip
    // it and count it as one error. Otherwise we have a mismatch; if
    // one of the strings is longer, increment its index, otherwise,
    // increment both indices and continue.
    //
    // This algorithm is an adaptation of a bool misspelling
    // algorithm proposed by Juergen Uhl.
    //
    var count = 0, prefix_length = 0, num_errors = 0;

    var i = 0, j = 0;
    while ((i < n) && (j < m)) {
      if (s1[i] == s2[j]) {
        count++;
        i++;
        j++;
        if (num_errors == 0) prefix_length++;
      } else if (s1[i + 1] == s2[j] && s1[i] == s2[j + 1]) // transposition
      {
        count += 2;
        i += 2;
        j += 2;
        num_errors++;
      } else if (s1[i + 1] == s2[j + 1]) // mismatch
      {
        i += 2;
        j += 2;
        num_errors++;
      } else {
        if ((n - i) > (m - j)) {
          i++;
        } else if ((m - j) > (n - i)) {
          j++;
        } else {
          i++;
          j++;
        }

        num_errors++;
      }
    }

    if (i < n || j < m) num_errors++;

    if (num_errors > ((n < m ? n : m) / 6 + 1)) count = prefix_length;

    return (count * 10 / ((n < s1.length ? s1.length : n) + num_errors))
        .floor();
  }

  void scopeTrial(PrimaryRepairInfo repair, List<int> stack, int stack_top) {
    if (stateSeen.length < stateStack.length) {
      stateSeen = List<int>.filled(stateStack.length, 0);
    }
    for (var i = 0; i < stateStack.length; i++) {
      stateSeen[i] = NIL;
    }

    statePoolTop = 0;
    if (statePool.length < stateStack.length) {
      statePool = List.filled(stateStack.length, null);
    }
    scopeTrialCheck(repair, stack, stack_top, 0);

    repair.code = SCOPE_CODE;
    repair.misspellIndex = 10;

    return;
  }

  void scopeTrialCheck(
      PrimaryRepairInfo repair, List<int> stack, int stack_top, int indx) {
    StateInfo? info;
    for (var i = stateSeen[stack_top]; i != NIL; i = info.next) {
      info = statePool[i];
      if (null == info) {
        break;
      }

      if (info.state == stack[stack_top]) return;
    }

    var old_state_pool_top = statePoolTop++;
    if (statePoolTop >= statePool.length) {
      ArrayList.copy(statePool, 0,
          statePool = List.filled(statePoolTop * 2, null), 0, statePoolTop);
    }

    statePool[old_state_pool_top] =
        StateInfo(stack[stack_top], stateSeen[stack_top]);
    stateSeen[stack_top] = old_state_pool_top;

    var action = IntTuple(1 << 3);
    for (var i = 0; i < SCOPE_SIZE; i++) {
      //
      // Compute the action (or set of actions in case of conflicts) that
      // can be executed on the scope lookahead symbol. Save the action(s)
      // in the action tuple.
      //
      action.reset();
      var act = tAction(stack[stack_top], scopeLa(i));
      if (act > ACCEPT_ACTION && act < ERROR_ACTION) // conflicting actions?
      {
        do {
          action.add(baseAction(act++));
        } while (baseAction(act) != 0);
      } else {
        action.add(act);
      }

      //
      // For each action defined on the scope lookahead symbol,
      // try scope recovery.
      //
      for (var action_index = 0; action_index < action.size(); action_index++) {
        tokStream.reset(buffer[repair.bufferPosition]);
        tempStackTop = stack_top - 1;
        var max_pos = stack_top;

        act = action.get(action_index);
        while (act <= NUM_RULES) {
          //
          // ... Process all goto-reduce actions following
          // reduction, until a goto action is computed ...
          //
          do {
            var lhs_symbol = lhs(act);
            tempStackTop -= (rhs(act) - 1);
            act = (tempStackTop > max_pos
                ? tempStack[tempStackTop]
                : stack[tempStackTop]);
            act = ntAction(act, lhs_symbol);
          } while (act <= NUM_RULES);
          if (tempStackTop + 1 >= stateStack.length) return;
          max_pos = max_pos < tempStackTop ? max_pos : tempStackTop;
          tempStack[tempStackTop + 1] = act;
          act = tAction(act, scopeLa(i));
        }

        //
        // If the lookahead symbol is parsable, then we check
        // whether or not we have a match between the scope
        // prefix and the transition symbols corresponding to
        // the states on top of the stack.
        //
        if (act != ERROR_ACTION) {
          int j, k = scopePrefix(i);
          for (j = tempStackTop + 1;
              j >= (max_pos + 1) && inSymbol(tempStack[j]) == scopeRhs(k);
              j--) {
            k++;
          }

          if (j == max_pos) {
            for (j = max_pos;
                j >= 1 && inSymbol(stack[j]) == scopeRhs(k);
                j--) {
              k++;
            }
          }
          //
          // If the prefix matches, check whether the state
          // newly exposed on top of the stack, (after the
          // corresponding prefix states are popped from the
          // stack), is in the set of "source states" for the
          // scope in question and that it is at a position
          // below the threshold indicated by MARKED_POS.
          //
          var marked_pos = (max_pos < stack_top ? max_pos + 1 : stack_top);
          if (scopeRhs(k) == 0 && j < marked_pos) // match?
          {
            var stack_position = j;
            for (j = scopeStateSet(i);
                stack[stack_position] != scopeState(j) && scopeState(j) != 0;
                j++) {
              ;
            }
            //
            // If the top state is valid for scope recovery,
            // the left-hand side of the scope is used as
            // starting symbol and we calculate how far the
            // parser can advance within the forward context
            // after parsing the left-hand symbol.
            //
            if (scopeState(j) != 0) // state was found
            {
              var previous_distance = repair.distance,
                  distance = parseCheck(stack, stack_position,
                      scopeLhs(i) + NT_OFFSET, repair.bufferPosition);
              //
              // if the recovery is not successful, we
              // update the stack with all actions induced
              // by the left-hand symbol, and recursively
              // call SCOPE_TRIAL_CHECK to try again.
              // Otherwise, the recovery is successful. If
              // the new distance is greater than the
              // initial SCOPE_DISTANCE, we update
              // SCOPE_DISTANCE and set scope_stack_top to INDX
              // to indicate the number of scopes that are
              // to be applied for a succesful  recovery.
              // NOTE that this procedure cannot get into
              // an infinite loop, since each prefix match
              // is guaranteed to take us to a lower point
              // within the stack.
              //
              if ((distance - repair.bufferPosition + 1) < MIN_DISTANCE) {
                var top = stack_position;
                act = ntAction(stack[top], scopeLhs(i));
                while (act <= NUM_RULES) {
                  top -= (rhs(act) - 1);
                  act = ntAction(stack[top], lhs(act));
                }
                top++;

                j = act;
                act = stack[top]; // save
                stack[top] = j; // swap
                scopeTrialCheck(repair, stack, top, indx + 1);
                stack[top] = act; // restore
              } else if (distance > repair.distance) {
                scopeStackTop = indx;
                repair.distance = distance;
              }

              //
              // If no other recovery possibility is left (due to
              // backtracking and we are at the end of the input,
              // then we favor a scope recovery over all other kinds
              // of recovery.
              //
              if ( // TODO: main_configuration_stack.size() == 0 && // no other bactracking possibilities left
                  tokStream.getKind(buffer[repair.bufferPosition]) ==
                          EOFT_SYMBOL &&
                      repair.distance == previous_distance) {
                scopeStackTop = indx;
                repair.distance = MAX_DISTANCE;
              }

              //
              // If this scope recovery has beaten the
              // previous distance, then we have found a
              // better recovery (or this recovery is one
              // of a list of scope recoveries). Record
              // its information at the proper location
              // (INDX) in SCOPE_INDEX and SCOPE_STACK.
              //
              if (repair.distance > previous_distance) {
                scopeIndex[indx] = i;
                scopePosition[indx] = stack_position;
                return;
              }
            }
          }
        }
      }
    }
  }

  //
  // This function computes the ParseCheck distance for the best
  // possible secondary recovery for a given configuration that
  // either deletes none or only one symbol in the forward context.
  // If the recovery found is more effective than the best primary
  // recovery previously computed, then the function returns true.
  // Only misplacement, scope and manual recoveries are attempted;
  // simple insertion or substitution of a nonterminal are tried
  // in CHECK_PRIMARY_DISTANCE as part of primary recovery.
  //
  bool secondaryCheck(
      List<int> stack, int stack_top, int buffer_position, int distance) {
    for (var top = stack_top - 1; top >= 0; top--) {
      var j = parseCheck(stack, top, tokStream.getKind(buffer[buffer_position]),
          buffer_position + 1);
      if (((j - buffer_position + 1) > MIN_DISTANCE) && (j > distance)) {
        return true;
      }
    }

    var scope_repair = PrimaryRepairInfo();
    scope_repair.bufferPosition = buffer_position + 1;
    scope_repair.distance = distance;
    scopeTrial(scope_repair, stack, stack_top);

    return ((scope_repair.distance - buffer_position) > MIN_DISTANCE &&
        scope_repair.distance > distance);
  }

  //
  // Secondary_phase is a bool function that checks whether or
  // not some form of secondary recovery is applicable to one of
  // the error configurations. First, if "next_stack" is available,
  // misplacement and secondary recoveries are attempted on it.
  // Then, in any case, these recoveries are attempted on "stack".
  // If a successful recovery is found, a diagnosis is issued, the
  // configuration is updated and the function returns "true".
  // Otherwise, the function returns false.
  //
  RepairCandidate secondaryPhase(int error_token) {
    var repair = SecondaryRepairInfo(),
        misplaced_repair = SecondaryRepairInfo();

    //
    // If the next_stack is available, try misplaced and secondary
    // recovery on it first.
    //
    var next_last_index = 0;
    if (nextStackTop >= 0) {
      int save_location;

      buffer[2] = error_token;
      buffer[1] = tokStream.getPrevious(buffer[2]);
      buffer[0] = tokStream.getPrevious(buffer[1]);

      for (var k = 3; k < BUFF_UBOUND; k++) {
        buffer[k] = tokStream.getNext(buffer[k - 1]);
      }

      buffer[BUFF_UBOUND] = tokStream.badToken(); // elmt not available

      //
      // If we are at the end of the input stream, compute the
      // index position of the first EOFT symbol (last useful
      // index).
      //
      for (next_last_index = MAX_DISTANCE - 1;
          next_last_index >= 1 &&
              tokStream.getKind(buffer[next_last_index]) == EOFT_SYMBOL;
          next_last_index--) {
        ;
      }
      next_last_index = next_last_index + 1;

      save_location = locationStack[nextStackTop];
      locationStack[nextStackTop] = buffer[2];
      misplaced_repair.numDeletions = nextStackTop;
      misplacementRecovery(
          misplaced_repair, nextStack, nextStackTop, next_last_index, true);
      if (misplaced_repair.recoveryOnNextStack) misplaced_repair.distance++;

      repair.numDeletions = nextStackTop + BUFF_UBOUND;
      secondaryRecovery(repair, nextStack, nextStackTop, next_last_index, true);
      if (repair.recoveryOnNextStack) repair.distance++;

      locationStack[nextStackTop] = save_location;
    } else // next_stack not available, initialize ...
    {
      misplaced_repair.numDeletions = stateStackTop;
      repair.numDeletions = stateStackTop + BUFF_UBOUND;
    }

    //
    // Try secondary recovery on the "stack" configuration.
    //
    buffer[3] = error_token;

    buffer[2] = tokStream.getPrevious(buffer[3]);
    buffer[1] = tokStream.getPrevious(buffer[2]);
    buffer[0] = tokStream.getPrevious(buffer[1]);

    for (var k = 4; k < BUFF_SIZE; k++) {
      buffer[k] = tokStream.getNext(buffer[k - 1]);
    }

    int last_index;
    for (last_index = MAX_DISTANCE - 1;
        last_index >= 1 && tokStream.getKind(buffer[last_index]) == EOFT_SYMBOL;
        last_index--) {
      ;
    }
    last_index++;

    misplacementRecovery(
        misplaced_repair, stateStack, stateStackTop, last_index, false);

    secondaryRecovery(repair, stateStack, stateStackTop, last_index, false);

    //
    // If a successful misplaced recovery was found, compare it with
    // the most successful secondary recovery.  If the misplaced
    // recovery either deletes fewer symbols or parse-checks further
    // then it is chosen.
    //
    if (misplaced_repair.distance > MIN_DISTANCE) {
      if (misplaced_repair.numDeletions <= repair.numDeletions ||
          (misplaced_repair.distance - misplaced_repair.numDeletions) >=
              (repair.distance - repair.numDeletions)) {
        repair.code = MISPLACED_CODE;
        repair.stackPosition = misplaced_repair.stackPosition;
        repair.bufferPosition = 2;
        repair.numDeletions = misplaced_repair.numDeletions;
        repair.distance = misplaced_repair.distance;
        repair.recoveryOnNextStack = misplaced_repair.recoveryOnNextStack;
      }
    }

    //
    // If the successful recovery was on next_stack, update: stack,
    // buffer, location_stack and last_index.
    //
    if (repair.recoveryOnNextStack) {
      stateStackTop = nextStackTop;
      ArrayList.copy(nextStack, 0, stateStack, 0, stateStackTop + 1);

      buffer[2] = error_token;
      buffer[1] = tokStream.getPrevious(buffer[2]);
      buffer[0] = tokStream.getPrevious(buffer[1]);

      for (var k = 3; k < BUFF_UBOUND; k++) {
        buffer[k] = tokStream.getNext(buffer[k - 1]);
      }

      buffer[BUFF_UBOUND] = tokStream.badToken(); // elmt not available

      locationStack[nextStackTop] = buffer[2];
      last_index = next_last_index;
    }

    //
    // Next, try scope recoveries after deletion of one, two, three,
    // four ... buffer_position tokens from the input stream.
    //
    if (repair.code == SECONDARY_CODE || repair.code == DELETION_CODE) {
      var scope_repair = PrimaryRepairInfo();
      for (scope_repair.bufferPosition = 2;
          scope_repair.bufferPosition <= repair.bufferPosition &&
              repair.code != SCOPE_CODE;
          scope_repair.bufferPosition++) {
        scopeTrial(scope_repair, stateStack, stateStackTop);
        var j = (scope_repair.distance == MAX_DISTANCE
                ? last_index
                : scope_repair.distance),
            k = scope_repair.bufferPosition - 1;
        if ((scope_repair.distance - k) > MIN_DISTANCE &&
            (j - k) > (repair.distance - repair.numDeletions)) {
          var i = scopeIndex[scopeStackTop]; // upper bound
          repair.code = SCOPE_CODE;
          repair.symbol = scopeLhs(i) + NT_OFFSET;
          repair.stackPosition = stateStackTop;
          repair.bufferPosition = scope_repair.bufferPosition;
        }
      }
    }

    //
    // If a successful repair was not found, quit!  Otherwise, issue
    // diagnosis and adjust configuration...
    //
    var candidate = RepairCandidate();
    if (repair.code == 0) return candidate;

    secondaryDiagnosis(repair);

    //
    // Update buffer based on number of elements that are deleted.
    //
    switch (repair.code) {
      case MISPLACED_CODE:
        candidate.location = buffer[2];
        candidate.symbol = tokStream.getKind(buffer[2]);
        tokStream.reset(tokStream.getNext(buffer[2]));

        break;

      case DELETION_CODE:
        candidate.location = buffer[repair.bufferPosition];
        candidate.symbol = tokStream.getKind(buffer[repair.bufferPosition]);
        tokStream.reset(tokStream.getNext(buffer[repair.bufferPosition]));

        break;

      default: // SCOPE_CODE || SECONDARY_CODE
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition]);

        break;
    }

    return candidate;
  }

  //
  // This bool function checks whether or not a given
  // configuration yields a better misplacement recovery than
  // the best misplacement recovery computed previously.
  //
  void misplacementRecovery(SecondaryRepairInfo repair, List<int> stack,
      int stack_top, int last_index, bool stack_flag) {
    var previous_loc = buffer[2], stack_deletions = 0;

    for (var top = stack_top - 1; top >= 0; top--) {
      if (locationStack[top] < previous_loc) stack_deletions++;
      previous_loc = locationStack[top];

      var parse_distance =
              parseCheck(stack, top, tokStream.getKind(buffer[2]), 3),
          j = (parse_distance == MAX_DISTANCE ? last_index : parse_distance);
      if ((parse_distance > MIN_DISTANCE) &&
          (j - stack_deletions) > (repair.distance - repair.numDeletions)) {
        repair.stackPosition = top;
        repair.distance = j;
        repair.numDeletions = stack_deletions;
        repair.recoveryOnNextStack = stack_flag;
      }
    }

    return;
  }

  //
  // This function checks whether or not a given
  // configuration yields a better secondary recovery than the
  // best misplacement recovery computed previously.
  //
  void secondaryRecovery(SecondaryRepairInfo repair, List<int> stack,
      int stack_top, int last_index, bool stack_flag) {
    var previous_loc = buffer[2], stack_deletions = 0;

    for (var top = stack_top;
        top >= 0 && repair.numDeletions >= stack_deletions;
        top--) {
      if (locationStack[top] < previous_loc) stack_deletions++;
      previous_loc = locationStack[top];

      for (var i = 2;
          i <= (last_index - MIN_DISTANCE + 1) &&
              (repair.numDeletions >= (stack_deletions + i - 1));
          i++) {
        var parse_distance =
                parseCheck(stack, top, tokStream.getKind(buffer[i]), i + 1),
            j = (parse_distance == MAX_DISTANCE ? last_index : parse_distance);

        if ((parse_distance - i + 1) > MIN_DISTANCE) {
          var k = stack_deletions + i - 1;
          if ((k < repair.numDeletions) ||
              (j - k) > (repair.distance - repair.numDeletions) ||
              ((repair.code == SECONDARY_CODE) &&
                  (j - k) == (repair.distance - repair.numDeletions))) {
            repair.code = DELETION_CODE;
            repair.distance = j;
            repair.stackPosition = top;
            repair.bufferPosition = i;
            repair.numDeletions = k;
            repair.recoveryOnNextStack = stack_flag;
          }
        }

        for (var l = nasi(stack[top]); l >= 0 && nasr(l) != 0; l++) {
          var symbol = nasr(l) + NT_OFFSET;
          parse_distance = parseCheck(stack, top, symbol, i);
          j = (parse_distance == MAX_DISTANCE ? last_index : parse_distance);

          if ((parse_distance - i + 1) > MIN_DISTANCE) {
            var k = stack_deletions + i - 1;
            if (k < repair.numDeletions ||
                (j - k) > (repair.distance - repair.numDeletions)) {
              repair.code = SECONDARY_CODE;
              repair.symbol = symbol;
              repair.distance = j;
              repair.stackPosition = top;
              repair.bufferPosition = i;
              repair.numDeletions = k;
              repair.recoveryOnNextStack = stack_flag;
            }
          }
        }
      }
    }

    return;
  }

  //
  // This procedure is invoked to issue a secondary diagnosis and
  // adjust the input buffer.  The recovery in question is either
  // an automatic scope recovery, a manual scope recovery, a
  // secondary substitution or a secondary deletion.
  //
  void secondaryDiagnosis(SecondaryRepairInfo repair) {
    switch (repair.code) {
      case SCOPE_CODE:
        {
          if (repair.stackPosition < stateStackTop) {
            emitError(DELETION_CODE, terminalIndex(ERROR_SYMBOL),
                locationStack[repair.stackPosition], buffer[1]);
          }
          for (var i = 0; i < scopeStackTop; i++) {
            emitError(
                SCOPE_CODE,
                -scopeIndex[i],
                locationStack[scopePosition[i]],
                buffer[1],
                nonterminalIndex(scopeLhs(scopeIndex[i])));
          }

          repair.symbol = scopeLhs(scopeIndex[scopeStackTop]) + NT_OFFSET;
          stateStackTop = scopePosition[scopeStackTop];
          emitError(
              SCOPE_CODE,
              -scopeIndex[scopeStackTop],
              locationStack[scopePosition[scopeStackTop]],
              buffer[1],
              getNtermIndex(stateStack[stateStackTop], repair.symbol,
                  repair.bufferPosition));
          break;
        }
      default:
        emitError(
            repair.code,
            (repair.code == SECONDARY_CODE
                ? getNtermIndex(stateStack[repair.stackPosition], repair.symbol,
                    repair.bufferPosition)
                : terminalIndex(ERROR_SYMBOL)),
            locationStack[repair.stackPosition],
            buffer[repair.bufferPosition - 1]);
        stateStackTop = repair.stackPosition;
    }

    return;
  }

  //
  // This method is invoked by an LPG PARSER or a semantic
  // routine to process an error message.
  //
  void emitError(int msg_code, int name_index, int left_token, int right_token,
      [int scope_name_index = 0]) {
    var token_name =
        (name_index >= 0 && !(name(name_index).toUpperCase() == ('ERROR'))
            ? '\"' + name(name_index) + '\"'
            : '');

    if (msg_code == INVALID_CODE) {
      msg_code = token_name.isEmpty ? INVALID_CODE : INVALID_TOKEN_CODE;
    }

    if (msg_code == SCOPE_CODE) {
      token_name = '\"';
      for (var i = scopeSuffix(-name_index); scopeRhs(i) != 0; i++) {
        if (!isNullable(scopeRhs(i))) {
          var symbol_index = (scopeRhs(i) > NT_OFFSET
              ? nonterminalIndex(scopeRhs(i) - NT_OFFSET)
              : terminalIndex(scopeRhs(i)));
          if (name(symbol_index).isNotEmpty) {
            if (token_name.length > 1) {
              token_name += ' ';
            } // add a space separator
            token_name += name(symbol_index);
          }
        }
      }
      token_name += '\"';
    }

    tokStream.reportError(msg_code, left_token, right_token, token_name);

    return;
  }

  //
  // keep looking ahead until we compute a valid action
  //
  int lookahead(int act, int token) {
    act = prs.lookAhead(act - LA_STATE_OFFSET, tokStream.getKind(token));
    return (act > LA_STATE_OFFSET
        ? lookahead(act, tokStream.getNext(token))
        : act);
  }

  //
  // Compute the next action defined on act and sym. If this
  // action requires more lookahead, these lookahead symbols
  // are in the token stream beginning at the next token that
  // is yielded by peek().
  //
  int tAction(int act, int sym) {
    act = prs.tAction(act, sym);
    return (act > LA_STATE_OFFSET ? lookahead(act, tokStream.peek()) : act);
  }
}
