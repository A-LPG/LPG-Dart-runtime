import 'IAstVisitor.dart';
import 'Protocol.dart';
import 'Util.dart';

abstract class IAst {
  IAst? getNextAst();

  // GLR AST implementations override these to maintain the packed-forest
  // projection. They remain no-ops for deterministic generated ASTs.
  void setNextAst(IAst n) {}
  void resetNextAst() {}

  IAst? getParent();
  IToken getLeftIToken();
  IToken getRightIToken();
  List<IToken> getPrecedingAdjuncts();
  List<IToken> getFollowingAdjuncts();
  ArrayList getChildren();
  ArrayList getAllChildren();
  void accept(IAstVisitor v);
}
