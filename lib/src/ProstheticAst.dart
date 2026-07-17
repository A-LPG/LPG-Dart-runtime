import 'IAst.dart';
import 'Protocol.dart';

//
// A ProstheticAst is a factory that synthesizes an AST node for a "recover"
// nonterminal. When the backtracking parser replays a nonterminal ErrorToken
// that was inserted by scope recovery, it asks the RuleAction for its
// prosthetic-AST factories and invokes one with the error token to build a
// placeholder (prosthetic) node in place of throwing a BadParseException.
//
typedef ProstheticAst = IAst Function(IToken errorToken);

//
// Parsers generated with automatic_ast and %Recover symbols mix in this
// provider (see the parser templates) so the backtracking parser can obtain
// the factory array. The default returns null, keeping the historical throw
// behavior for grammars without %Recover.
//
mixin ProstheticAstProvider {
  List<ProstheticAst?>? getProstheticAst() => null;
}

//
// Tables generated with %Recover symbols implement this to map a replayed
// nonterminal token kind (NT_OFFSET already applied) to a compact slot in the
// ProstheticAstProvider.getProstheticAst() array; absent otherwise.
//
abstract class ProsthesisIndexProvider {
  int getProsthesisIndex(int index);
}
