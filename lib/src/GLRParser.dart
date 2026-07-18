import 'dart:collection';
import 'dart:math';

import 'BacktrackingParser.dart';
import 'BadParseException.dart';
import 'BadParseSymFileException.dart';
import 'GssEdge.dart';
import 'GssNode.dart';
import 'IAst.dart';
import 'Monitor.dart';
import 'NotBacktrackParseTableException.dart';
import 'NotGLRParseTableException.dart';
import 'ParseTable.dart';
import 'Protocol.dart';
import 'RuleAction.dart';
import 'SppfNode.dart';
import 'Stacks.dart';
import 'TokenStream.dart';
import 'UnavailableParserInformationException.dart';

/// Optional hook for GLR→BT recovery: generated GLR parsers implement this so
/// semantic accessors use BacktrackingParser stacks during %Recover replay.
abstract class GlrRecoverAction {
  void setRecoverParser(BacktrackingParser? parser);
  BacktrackingParser? getRecoverParser();
}

/// Generalized LR driver over LPG GLR conflict tables (GLR v2).
/// Configurations share GSS prefixes, reductions populate an SPPF, and
/// compatible AST alternatives are projected through [IAst.getNextAst].
class GLRParser extends Stacks {
  static final Object _NULL_RESULT = Object();
  static const int _GSS_BOTTOM_STATE = -0x8000000000000000;

  Monitor? monitor;
  int START_STATE = 0;
  int NUM_RULES = 0;
  int NT_OFFSET = 0;
  int LA_STATE_OFFSET = 0;
  int ACCEPT_ACTION = 0;
  int ERROR_ACTION = 0;

  TokenStream? tokStream;
  ParseTable? prs;
  RuleAction? ra;

  bool taking_actions = false;
  int currentAction = 0;
  int lastToken = 0;
  int parseStackRoot = 0;
  int frameTop = 0;
  List<int> frameLocation = [];
  List<Object?> frameParse = [];

  Map<_ReductionKey, IAst> familyCache = {};
  Map<_ForestKey, IAst> forestCache = {};
  Map<_GssKey, GssNode> gssNodes = {};
  Map<_SppfKey, SppfNode> sppfNodes = {};
  SppfNode? sppfRoot;
  int sppfSymbolCount = 0;

  GLRParser(
      [TokenStream? tokStream, ParseTable? prs, RuleAction? ra, Monitor? monitor]) {
    reset(tokStream, prs, ra, monitor);
  }

  int lookahead(int act, int token) {
    act = prs!.lookAhead(act - LA_STATE_OFFSET, tokStream!.getKind(token));
    if (act > LA_STATE_OFFSET) {
      return lookahead(act, tokStream!.getNext(token));
    }
    return act;
  }

  int tAction(int state, int sym, int curtok) {
    var act = prs!.tAction(state, sym);
    if (act > LA_STATE_OFFSET) {
      return lookahead(act, tokStream!.getNext(curtok));
    }
    return act;
  }

  List<int> _expandConflict(int act) {
    final result = <int>[];
    for (var i = act;; i++) {
      final candidate = prs!.baseAction(i);
      if (candidate == 0) break;
      result.add(candidate);
    }
    return result;
  }

  int getCurrentRule() {
    if (taking_actions) return currentAction;
    throw UnavailableParserInformationException();
  }

  @override
  int getToken(int i) {
    if (taking_actions) {
      return frameLocation[frameTop + (i - 1)];
    }
    return super.getToken(i);
  }

  @override
  Object? getSym(int i) {
    if (taking_actions) {
      return frameParse[frameTop + (i - 1)];
    }
    return super.getSym(i);
  }

  @override
  void setSym1(Object? ast) {
    if (taking_actions) {
      frameParse[frameTop] = ast;
    } else {
      super.setSym1(ast);
    }
  }

  int getFirstToken([int? i]) {
    if (!taking_actions) {
      throw UnavailableParserInformationException();
    }
    return getToken(i ?? 1);
  }

  int getLastToken([int? i]) {
    if (!taking_actions) {
      throw UnavailableParserInformationException();
    }
    if (i == null) return lastToken;
    if (i >= prs!.rhs(currentAction)) return lastToken;
    return tokStream!.getPrevious(getToken(i + 1));
  }

  SppfNode? getSppfRoot() => sppfRoot;

  int getSppfSymbolCount() => sppfSymbolCount;

  void setMonitor(Monitor? monitor) {
    this.monitor = monitor;
  }

  void reset1() {
    taking_actions = false;
    sppfRoot = null;
    sppfSymbolCount = 0;
  }

  void reset2(TokenStream tokStream, [Monitor? monitor]) {
    this.monitor = monitor;
    this.tokStream = tokStream;
    reset1();
  }

  void reset(
      [TokenStream? tokStream,
      ParseTable? prs,
      RuleAction? ra,
      Monitor? monitor]) {
    if (prs != null) {
      this.prs = prs;
      START_STATE = prs.getStartState();
      NUM_RULES = prs.getNumRules();
      NT_OFFSET = prs.getNtOffset();
      LA_STATE_OFFSET = prs.getLaStateOffset();
      ACCEPT_ACTION = prs.getAcceptAction();
      ERROR_ACTION = prs.getErrorAction();
      if (!prs.isValidForParser()) {
        throw BadParseSymFileException();
      }
      if (!prs.isGLR()) {
        throw NotGLRParseTableException();
      }
    }
    if (ra != null) {
      this.ra = ra;
    }
    if (tokStream == null) {
      reset1();
      return;
    }
    reset2(tokStream, monitor);
  }

  Object? parse([int max_error_count = 0]) {
    return parseEntry(0, max_error_count);
  }

  Object? parseEntry([int marker_kind = 0, int max_error_count = 0]) {
    try {
      return _parseEntryNoRepair(marker_kind);
    } on BadParseException {
      if (max_error_count <= 0) rethrow;
      try {
        final parser =
            BacktrackingParser(tokStream, prs, ra, monitor);
        final action = ra;
        final recover = action is GlrRecoverAction
            ? action as GlrRecoverAction
            : null;
        recover?.setRecoverParser(parser);
        try {
          return parser.fuzzyParseEntry(marker_kind, max_error_count);
        } finally {
          recover?.setRecoverParser(null);
        }
      } on BadParseSymFileException catch (e) {
        throw StateError(e.toString());
      } on NotBacktrackParseTableException catch (e) {
        throw StateError(e.toString());
      }
    }
  }

  Object? _parseEntryNoRepair(int marker_kind) {
    tokStream!.reset();
    familyCache = {};
    forestCache = {};
    gssNodes = {};
    sppfNodes = {};
    sppfRoot = null;

    final firstTok = tokStream!.getToken();
    final previous = tokStream!.getPrevious(firstTok);
    final startTok = marker_kind == 0 ? firstTok : previous;
    final startKind =
        marker_kind == 0 ? tokStream!.getKind(firstTok) : marker_kind;
    parseStackRoot = marker_kind == 0 ? 0 : 1;

    final start = _Config();
    start.stateStackTop = -1;
    start.currentAction = START_STATE;
    start.curtok = startTok;
    start.lastToken = previous;
    start.currentKind = startKind;
    _ensureCapacity(start, 16);

    var live = <_Config>[start];
    final accepts = <_AcceptCandidate>[];
    var errorTok = startTok;
    var guard = prs!.getNumStates() * 64 +
        tokStream!.getStreamLength() * 8 +
        256;

    while (live.isNotEmpty) {
      if (monitor != null && monitor!.isCancelled()) {
        return null;
      }
      if (--guard < 0) {
        throw StateError(
            'cyclic/epsilon-loop grammar not supported by GLR v2');
      }

      final next = <_Config>[];
      final packed = <_ConfigKey, List<_Config>>{};

      for (final config in live) {
        if (config.curtok > errorTok) errorTok = config.curtok;

        final stepResults = <_Config>[];
        final stepAccepts = <_AcceptCandidate>[];
        _stepConfig(config, stepResults, stepAccepts);

        for (final candidate in stepAccepts) {
          _packAccept(accepts, candidate);
        }

        for (final result in stepResults) {
          final key = _ConfigKey(result);
          var bucket = packed[key];
          if (bucket == null) {
            bucket = [result];
            packed[key] = bucket;
            next.add(result);
            continue;
          }
          var merged = false;
          for (final existing in bucket) {
            if (_canPackParseStacks(existing, result)) {
              _packParseStacks(existing, result);
              merged = true;
              break;
            }
          }
          if (!merged) {
            bucket.add(result);
            next.add(result);
          }
        }
      }

      if (accepts.isNotEmpty && next.isEmpty) break;
      live = next;
      if (live.isEmpty && accepts.isEmpty) {
        throw BadParseException(errorTok);
      }
    }

    if (accepts.isEmpty) {
      throw BadParseException(errorTok);
    }

    var root = accepts[0].ast;
    final rootSymbol = accepts[0].grammarSymbol;
    sppfRoot = accepts[0].sppf;
    for (var i = 1; i < accepts.length; i++) {
      final other = accepts[i];
      if (other.grammarSymbol != rootSymbol) {
        throw StateError('GLR accepted distinct start symbols');
      }
      sppfRoot ??= other.sppf;
      if (!_appendNextAst(root, other.ast)) {
        throw StateError('overlapping GLR accept forests');
      }
    }
    sppfSymbolCount = sppfNodes.length;
    return identical(root, _NULL_RESULT) ? null : root;
  }

  void _stepConfig(
      _Config config, List<_Config> out, List<_AcceptCandidate> accepts) {
    final work = <_Config>[config.copy()];
    var guard = prs!.getNumStates() * 4 + 8;

    while (work.isNotEmpty) {
      if (--guard < 0) {
        throw StateError(
            'cyclic/epsilon-loop grammar not supported by GLR v2');
      }
      final current = work.removeLast();
      _ensureCapacity(current, current.stateStackTop + 2);
      current.stateStackTop += 1;
      final top = current.stateStackTop;
      current.stateStack[top] = current.currentAction;
      current.locationStack[top] = current.curtok;
      current.symbolStack[top] = 0;
      current.sppfStack[top] = null;
      if (top != parseStackRoot) {
        current.parseStack[top] = null;
      }
      current.gssTip = _gssPush(
          current.gssTip, current.currentAction, current.curtok, 0, null, null);

      final act =
          tAction(current.currentAction, current.currentKind, current.curtok);
      final candidates = (act > ACCEPT_ACTION && act < ERROR_ACTION)
          ? _expandConflict(act)
          : <int>[act];

      for (final candidate in candidates) {
        final fork = candidates.length == 1 ? current : current.copy();
        _applyConcreteAction(fork, candidate, work, out, accepts);
      }
    }
  }

  void _applyConcreteAction(_Config fork, int candidate, List<_Config> work,
      List<_Config> out, List<_AcceptCandidate> accepts) {
    if (candidate <= NUM_RULES) {
      fork.stateStackTop -= 1;
      fork.gssTip = _gssPop(fork.gssTip);
      _applyReduceClosure(fork, candidate, work);
    } else if (candidate > ERROR_ACTION) {
      final top = fork.stateStackTop;
      fork.symbolStack[top] = fork.currentKind;
      final terminal = _terminalSppf(fork.currentKind, fork.curtok);
      fork.sppfStack[top] = terminal;
      fork.gssTip = _gssRelabel(
          fork.gssTip, fork.currentKind, fork.curtok, null, terminal);
      fork.lastToken = fork.curtok;
      fork.curtok = tokStream!.getNext(fork.curtok);
      fork.currentKind = tokStream!.getKind(fork.curtok);
      _applyReduceClosure(fork, candidate - ERROR_ACTION, work);
    } else if (candidate < ACCEPT_ACTION) {
      final top = fork.stateStackTop;
      fork.symbolStack[top] = fork.currentKind;
      final terminal = _terminalSppf(fork.currentKind, fork.curtok);
      fork.sppfStack[top] = terminal;
      fork.gssTip = _gssRelabel(
          fork.gssTip, fork.currentKind, fork.curtok, null, terminal);
      fork.lastToken = fork.curtok;
      fork.curtok = tokStream!.getNext(fork.curtok);
      fork.currentKind = tokStream!.getKind(fork.curtok);
      fork.currentAction = candidate;
      out.add(fork);
    } else if (candidate == ACCEPT_ACTION) {
      Object? root;
      var rootSymbol = 0;
      SppfNode? rootSppf;
      if (parseStackRoot < fork.parseStack.length) {
        root = fork.parseStack[parseStackRoot];
      }
      if (parseStackRoot <= fork.stateStackTop) {
        rootSymbol = fork.symbolStack[parseStackRoot];
      }
      if (parseStackRoot < fork.sppfStack.length) {
        rootSppf = fork.sppfStack[parseStackRoot];
      }
      accepts.add(_AcceptCandidate(
          root ?? _NULL_RESULT, rootSymbol, rootSppf));
    }
  }

  void _applyReduceClosure(_Config fork, int rule, List<_Config> work) {
    var action = rule;
    while (true) {
      final rhs = prs!.rhs(action);
      if (fork.stateStackTop - (rhs - 1) < 0) {
        throw StateError('GLR reduce stack underflow');
      }

      final children = List<SppfNode?>.generate(
          rhs, (i) => fork.sppfStack[fork.stateStackTop - rhs + 1 + i]);

      fork.stateStackTop -= rhs - 1;
      if (rhs > 0) {
        for (var i = 0; i < rhs - 1; i++) {
          fork.gssTip = _gssPop(fork.gssTip);
        }
      } else {
        _ensureCapacity(fork, fork.stateStackTop + 1);
        final top = fork.stateStackTop;
        fork.gssTip = _gssPush(fork.gssTip, fork.stateStack[top],
            fork.locationStack[top], 0, null, null);
      }

      final top = fork.stateStackTop;
      final reductionKey = _ReductionKey(
          action, fork.lastToken, rhs, top, fork.locationStack,
          fork.symbolStack, fork.parseStack);
      currentAction = action;
      lastToken = fork.lastToken;
      frameTop = top;
      frameLocation = fork.locationStack;
      frameParse = fork.parseStack;

      taking_actions = true;
      try {
        ra!.ruleAction(action);
      } finally {
        taking_actions = false;
      }

      final lhs = prs!.lhs(action);
      final lhsSymbol = NT_OFFSET + lhs;
      var semantic = fork.parseStack[top];
      if (semantic is IAst) {
        var canonical = familyCache[reductionKey];
        if (canonical == null) {
          final forestKey = _ForestKey(lhsSymbol, semantic);
          if (forestKey.isPackable()) {
            canonical = forestCache[forestKey];
          }
          if (canonical == null) {
            canonical = semantic;
            if (forestKey.isPackable()) {
              forestCache[forestKey] = canonical;
            }
          } else if (!identical(canonical, semantic) &&
              !_appendNextAst(canonical, semantic)) {
            throw StateError('cannot merge GLR production family');
          }
          familyCache[reductionKey] = canonical;
        }
        fork.parseStack[top] = canonical;
        semantic = canonical;
      }

      var leftExtent = fork.locationStack[top];
      var rightExtent = fork.lastToken;
      if (semantic is IAst) {
        final left = semantic.getLeftIToken();
        final right = semantic.getRightIToken();
        leftExtent = left.getTokenIndex();
        rightExtent = right.getTokenIndex();
      }

      final symbolNode = _sppfSymbol(lhsSymbol, leftExtent, rightExtent);
      _addPacked(symbolNode, action, children, semantic);
      if (semantic is IAst) {
        symbolNode.astForest = semantic;
      }
      fork.sppfStack[top] = symbolNode;
      fork.symbolStack[top] = lhsSymbol;
      fork.gssTip =
          _gssRelabel(fork.gssTip, lhsSymbol, leftExtent, semantic, symbolNode);
      action = prs!.ntAction(fork.stateStack[top], lhs);
      if (action > NUM_RULES) break;
    }

    fork.currentAction = action;
    work.add(fork);
  }

  void _ensureCapacity(_Config config, int need) {
    final length = config.stateStack.length;
    if (need < length) return;
    final newLength = max(need + 8, length + STACK_INCREMENT);
    final extension = newLength - length;
    config.stateStack.addAll(List.filled(extension, 0));
    config.symbolStack.addAll(List.filled(extension, 0));
    config.parseStack.addAll(List.filled(extension, null));
    config.locationStack.addAll(List.filled(extension, 0));
    config.sppfStack.addAll(List.filled(extension, null));
  }

  SppfNode _sppfSymbol(int grammarSymbol, int left, int right) {
    final key = _SppfKey(grammarSymbol, left, right);
    var node = sppfNodes[key];
    if (node == null) {
      node = SppfNode(grammarSymbol, left, right);
      sppfNodes[key] = node;
    }
    return node;
  }

  SppfNode _terminalSppf(int kind, int token) {
    final terminal = _sppfSymbol(kind, token, token);
    if (terminal.packs.isEmpty) {
      terminal.packs.add(SppfPacked(-kind));
    }
    return terminal;
  }

  void _addPacked(
      SppfNode symbolNode, int rule, List<SppfNode?>? children, Object? semantic) {
    final kids = children ?? <SppfNode?>[];
    for (final packed in symbolNode.packs) {
      if (packed.rule != rule || packed.children.length != kids.length) {
        continue;
      }
      var same = true;
      for (var i = 0; i < kids.length; i++) {
        if (!identical(packed.children[i], kids[i])) {
          same = false;
          break;
        }
      }
      if (same) return;
    }
    symbolNode.packs.add(SppfPacked(rule, kids, semantic));
  }

  GssNode _gssPush(GssNode? tip, int state, int index, int symbol,
      Object? semantic, SppfNode? sppf) {
    final node = GssNode(state, index);
    final predecessor = tip ?? GssNode(_GSS_BOTTOM_STATE, -1);
    node.edges.add(GssEdge(predecessor, symbol, index, semantic, sppf));
    final key = _GssKey(state, index);
    var canonical = gssNodes[key];
    if (canonical == null) {
      canonical = GssNode(state, index);
      gssNodes[key] = canonical;
    }
    canonical.edges.add(GssEdge(predecessor, symbol, index, semantic, sppf));
    return node;
  }

  static GssNode? _gssPop(GssNode? tip) {
    if (tip == null || tip.edges.isEmpty) return null;
    final predecessor = tip.edges[0].predecessor;
    return predecessor.state == _GSS_BOTTOM_STATE ? null : predecessor;
  }

  static GssNode? _gssRelabel(GssNode? tip, int symbol, int location,
      Object? semantic, SppfNode? sppf) {
    if (tip == null || tip.edges.isEmpty) return tip;
    final node = GssNode(tip.state, tip.index);
    node.edges.add(GssEdge(
        tip.edges[0].predecessor, symbol, location, semantic, sppf));
    return node;
  }

  void _packAccept(List<_AcceptCandidate> accepts, _AcceptCandidate candidate) {
    final ast = candidate.ast;
    if (identical(ast, _NULL_RESULT)) {
      for (final existing in accepts) {
        if (identical(existing.ast, _NULL_RESULT)) return;
      }
      accepts.add(candidate);
      return;
    }
    for (final existing in accepts) {
      if (identical(existing.ast, _NULL_RESULT)) continue;
      if (existing.grammarSymbol == candidate.grammarSymbol &&
          _sameSpan(existing.ast, ast) &&
          _appendNextAst(existing.ast, ast)) {
        return;
      }
    }
    accepts.add(candidate);
  }

  bool _canPackParseStacks(_Config existing, _Config incoming) {
    if (existing.stateStackTop != incoming.stateStackTop) return false;
    for (var i = 0; i <= existing.stateStackTop; i++) {
      final a = existing.parseStack[i];
      final b = incoming.parseStack[i];
      if (identical(a, b)) continue;
      if (a is! IAst ||
          b is! IAst ||
          !_sameSpan(a, b) ||
          !_appendNextAst(a, b, false)) {
        return false;
      }
    }
    return true;
  }

  void _packParseStacks(_Config existing, _Config incoming) {
    for (var i = 0; i <= existing.stateStackTop; i++) {
      final a = existing.parseStack[i];
      final b = incoming.parseStack[i];
      if (identical(a, b) || a == null || b == null) continue;
      if (!_appendNextAst(a, b, false)) {
        throw StateError('overlapping GLR semantic forests');
      }
    }

    for (var i = 0; i <= existing.stateStackTop; i++) {
      existing.parseStack[i] =
          _packSym(existing.parseStack[i], incoming.parseStack[i]);
      final firstSppf = existing.sppfStack[i];
      final secondSppf = incoming.sppfStack[i];
      if (firstSppf == null) {
        existing.sppfStack[i] = secondSppf;
      } else if (secondSppf != null &&
          !identical(firstSppf, secondSppf) &&
          firstSppf.grammarSymbol == secondSppf.grammarSymbol &&
          firstSppf.leftExtent == secondSppf.leftExtent &&
          firstSppf.rightExtent == secondSppf.rightExtent) {
        for (final packed in secondSppf.packs) {
          _addPacked(
              firstSppf, packed.rule, packed.children, packed.semantic);
        }
        if (existing.parseStack[i] is IAst) {
          firstSppf.astForest = existing.parseStack[i];
        }
      }
    }
    if (incoming.gssTip != null) {
      existing.gssTip = incoming.gssTip;
    }
  }

  static Object? _packSym(Object? first, Object? second) {
    if (first == null) return second;
    if (second == null || identical(first, second)) return first;
    if (!_appendNextAst(first, second)) {
      throw StateError('overlapping GLR semantic forests');
    }
    return first;
  }

  static bool _sameSpan(Object? first, Object? second) {
    if (first is! IAst || second is! IAst) return false;
    final leftA = first.getLeftIToken();
    final rightA = first.getRightIToken();
    final leftB = second.getLeftIToken();
    final rightB = second.getRightIToken();
    return identical(leftA.getILexStream(), leftB.getILexStream()) &&
        identical(rightA.getILexStream(), rightB.getILexStream()) &&
        leftA.getTokenIndex() == leftB.getTokenIndex() &&
        rightA.getTokenIndex() == rightB.getTokenIndex();
  }

  static bool _appendNextAst(Object? root, Object? alternative,
      [bool commit = true]) {
    if (root is! IAst || alternative is! IAst) return false;
    if (identical(root, alternative)) return true;

    final seen = HashSet<IAst>.identity();
    IAst? tail;
    for (IAst? node = root; node != null; node = node.getNextAst()) {
      if (!seen.add(node)) return false;
      tail = node;
    }

    final incoming = HashSet<IAst>.identity();
    for (IAst? node = alternative; node != null;) {
      if (!incoming.add(node)) return false;
      if (seen.contains(node)) {
        node = node.getNextAst();
        continue;
      }
      for (IAst? next = node.getNextAst();
          next != null;
          next = next.getNextAst()) {
        if (!incoming.add(next) || seen.contains(next)) return false;
      }
      if (commit) {
        if (tail == null) return false;
        tail.setNextAst(node);
        for (IAst? next = node; next != null; next = next.getNextAst()) {
          seen.add(next);
          tail = next;
        }
      }
      return true;
    }
    return true;
  }
}

class _AcceptCandidate {
  final Object ast;
  final int grammarSymbol;
  final SppfNode? sppf;

  _AcceptCandidate(this.ast, this.grammarSymbol, this.sppf);
}

class _Config {
  List<int> stateStack = [];
  List<int> symbolStack = [];
  List<Object?> parseStack = [];
  List<int> locationStack = [];
  List<SppfNode?> sppfStack = [];
  GssNode? gssTip;
  int stateStackTop = 0;
  int currentAction = 0;
  int curtok = 0;
  int lastToken = 0;
  int currentKind = 0;

  _Config copy() {
    final result = _Config();
    result.stateStack = List<int>.from(stateStack);
    result.symbolStack = List<int>.from(symbolStack);
    result.parseStack = List<Object?>.from(parseStack);
    result.locationStack = List<int>.from(locationStack);
    result.sppfStack = List<SppfNode?>.from(sppfStack);
    result.gssTip = gssTip;
    result.stateStackTop = stateStackTop;
    result.currentAction = currentAction;
    result.curtok = curtok;
    result.lastToken = lastToken;
    result.currentKind = currentKind;
    return result;
  }
}

class _ConfigKey {
  final _Config config;
  late final int _hash;

  _ConfigKey(this.config) {
    var h = 31 * config.curtok + config.currentKind;
    h = 31 * h + config.lastToken;
    h = 31 * h + config.currentAction;
    for (var i = 0; i <= config.stateStackTop; i++) {
      h = 31 * h + config.stateStack[i];
      h = 31 * h + config.locationStack[i];
      h = 31 * h + config.symbolStack[i];
    }
    _hash = h;
  }

  @override
  int get hashCode => _hash;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! _ConfigKey) return false;
    final a = config;
    final b = other.config;
    if (a.curtok != b.curtok ||
        a.currentKind != b.currentKind ||
        a.lastToken != b.lastToken ||
        a.currentAction != b.currentAction ||
        a.stateStackTop != b.stateStackTop) {
      return false;
    }
    for (var i = 0; i <= a.stateStackTop; i++) {
      if (a.stateStack[i] != b.stateStack[i] ||
          a.locationStack[i] != b.locationStack[i] ||
          a.symbolStack[i] != b.symbolStack[i]) {
        return false;
      }
    }
    return true;
  }
}

class _ReductionKey {
  final int rule;
  final int lastToken;
  final List<int> locations;
  final List<int> grammarSymbols;
  final List<Object?> semanticValues;
  late final int _hash;

  _ReductionKey(this.rule, this.lastToken, int rhs, int frameTop,
      List<int> locationStack, List<int> symbolStack, List<Object?> parseStack)
      : locations = List<int>.filled(rhs, 0),
        grammarSymbols = List<int>.filled(rhs, 0),
        semanticValues = List<Object?>.filled(rhs, null) {
    var h = 31 * rule + lastToken;
    for (var i = 0; i < rhs; i++) {
      final index = frameTop + i;
      locations[i] = locationStack[index];
      grammarSymbols[i] = symbolStack[index];
      semanticValues[i] = parseStack[index];
      h = 31 * h + locations[i];
      h = 31 * h + grammarSymbols[i];
      h = 31 * h + identityHashCode(semanticValues[i]);
    }
    _hash = h;
  }

  @override
  int get hashCode => _hash;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! _ReductionKey) return false;
    if (rule != other.rule ||
        lastToken != other.lastToken ||
        locations.length != other.locations.length) {
      return false;
    }
    for (var i = 0; i < locations.length; i++) {
      if (locations[i] != other.locations[i] ||
          grammarSymbols[i] != other.grammarSymbols[i] ||
          !identical(semanticValues[i], other.semanticValues[i])) {
        return false;
      }
    }
    return true;
  }
}

class _ForestKey {
  final int grammarSymbol;
  final ILexStream? lexStream;
  final int leftToken;
  final int rightToken;
  late final int _hash;

  _ForestKey(this.grammarSymbol, IAst ast)
      : lexStream = ast.getLeftIToken().getILexStream(),
        leftToken = ast.getLeftIToken().getTokenIndex(),
        rightToken = ast.getRightIToken().getTokenIndex() {
    var h = 31 * grammarSymbol + identityHashCode(lexStream);
    h = 31 * h + leftToken;
    _hash = 31 * h + rightToken;
  }

  bool isPackable() => leftToken >= 0 && rightToken >= 0;

  @override
  int get hashCode => _hash;

  @override
  bool operator ==(Object other) {
    if (other is! _ForestKey) return false;
    return grammarSymbol == other.grammarSymbol &&
        identical(lexStream, other.lexStream) &&
        leftToken == other.leftToken &&
        rightToken == other.rightToken;
  }
}

class _GssKey {
  final int state;
  final int index;

  const _GssKey(this.state, this.index);

  @override
  int get hashCode => 31 * state + index;

  @override
  bool operator ==(Object other) {
    return other is _GssKey && state == other.state && index == other.index;
  }
}

class _SppfKey {
  final int symbol;
  final int left;
  final int right;

  const _SppfKey(this.symbol, this.left, this.right);

  @override
  int get hashCode => (31 * symbol + left) * 31 + right;

  @override
  bool operator ==(Object other) {
    return other is _SppfKey &&
        symbol == other.symbol &&
        left == other.left &&
        right == other.right;
  }
}
