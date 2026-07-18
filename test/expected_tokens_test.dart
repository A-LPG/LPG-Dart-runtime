import 'package:lpg2/lpg2.dart';
import 'package:test/test.dart';

class _MockTable implements ParseTable {
  @override
  int getErrorAction() => 0;

  @override
  int getNtOffset() => 4;

  @override
  int tAction(int state, int sym) =>
      state == 0 && (sym == 1 || sym == 2) ? 1 : 0;

  @override
  int terminalIndex(int sym) => sym;

  @override
  String name(int index) {
    if (index == 1) return 'a';
    if (index == 2) return 'b';
    return '';
  }

  @override
  int baseCheck(int index) => 0;
  @override
  int rhs(int index) => 0;
  @override
  int baseAction(int index) => 0;
  @override
  int lhs(int index) => 0;
  @override
  int termCheck(int index) => 0;
  @override
  int termAction(int index) => 0;
  @override
  int asb(int index) => 0;
  @override
  int asr(int index) => 0;
  @override
  int nasb(int index) => 0;
  @override
  int nasr(int index) => 0;
  @override
  int nonterminalIndex(int index) => 0;
  @override
  int scopePrefix(int index) => 0;
  @override
  int scopeSuffix(int index) => 0;
  @override
  int scopeLhs(int index) => 0;
  @override
  int scopeLa(int index) => 0;
  @override
  int scopeStateSet(int index) => 0;
  @override
  int scopeRhs(int index) => 0;
  @override
  int scopeState(int index) => 0;
  @override
  int inSymb(int index) => 0;
  @override
  int originalState(int state) => 0;
  @override
  int asi(int state) => 0;
  @override
  int nasi(int state) => 0;
  @override
  int inSymbol(int state) => 0;
  @override
  int ntAction(int state, int sym) => 0;
  @override
  int lookAhead(int act, int sym) => 0;
  @override
  int getErrorSymbol() => 0;
  @override
  int getScopeUbound() => 0;
  @override
  int getScopeSize() => 0;
  @override
  int getMaxNameLength() => 0;
  @override
  int getNumStates() => 0;
  @override
  int getLaStateOffset() => 0;
  @override
  int getMaxLa() => 0;
  @override
  int getNumRules() => 0;
  @override
  int getNumNonterminals() => 0;
  @override
  int getNumSymbols() => 0;
  @override
  int getSegmentSize() => 0;
  @override
  int getStartState() => 0;
  @override
  int getStartSymbol() => 0;
  @override
  int getEoftSymbol() => 0;
  @override
  int getEoltSymbol() => 0;
  @override
  int getAcceptAction() => 0;
  @override
  bool isNullable(int symbol) => false;
  @override
  bool isValidForParser() => true;
  @override
  bool getBacktrack() => false;
  @override
  int getProsthesisIndex(int kind) => 0;
}

void main() {
  test('expectedTerminalNames returns sorted legal terminals', () {
    final prs = _MockTable();
    expect(expectedTerminalNames(prs, 0), ['a', 'b']);
  });

  test('ParseIssue.mismatch fills expected from state', () {
    final prs = _MockTable();
    final issue = ParseIssue.mismatch(
      prs,
      0,
      ERROR_CODE,
      const SourceSpan(1, 1),
      'x',
    );
    expect(issue.code, ERROR_CODE);
    expect(issue.expected, ['a', 'b']);
    expect(issue.got, 'x');
  });
}
