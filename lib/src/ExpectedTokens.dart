/// Expected-terminals helper for editor completion (antlr4-c3 style).

import 'ParseTable.dart';

List<String> expectedTerminalNames(ParseTable? prs, int state) {
  if (prs == null) {
    return const [];
  }

  final errorAction = prs.getErrorAction();
  final ntOffset = prs.getNtOffset();
  final unique = <String>{};
  for (var sym = 1; sym < ntOffset; sym++) {
    final act = prs.tAction(state, sym);
    if (act == errorAction) {
      continue;
    }
    final n = prs.name(prs.terminalIndex(sym));
    if (n.isNotEmpty) {
      unique.add(n);
    }
  }
  final out = unique.toList()..sort();
  return out;
}
