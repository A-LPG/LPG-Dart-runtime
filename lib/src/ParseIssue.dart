/// Unified parse-error shape: code / span / expected / got.

import 'ExpectedTokens.dart';
import 'ParseTable.dart';

class SourceSpan {
  final int startOffset;
  final int endOffset;

  const SourceSpan(this.startOffset, this.endOffset);
}

class ParseIssue {
  final int code;
  final SourceSpan span;
  final List<String> expected;
  final String got;

  const ParseIssue({
    required this.code,
    required this.span,
    required this.expected,
    required this.got,
  });

  factory ParseIssue.mismatch(
    ParseTable? prs,
    int state,
    int code,
    SourceSpan span,
    String got,
  ) {
    return ParseIssue(
      code: code,
      span: span,
      expected: expectedTerminalNames(prs, state),
      got: got,
    );
  }
}
