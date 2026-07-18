/// One packed alternative under a shared symbol/span node.
class SppfPacked {
  final int rule;
  final List<SppfNode?> children;
  final Object? semantic;

  SppfPacked(this.rule, [List<SppfNode?>? children, this.semantic])
      : children = children ?? <SppfNode?>[];

  int getRule() => rule;

  List<SppfNode> getChildren() {
    final result = <SppfNode>[];
    for (final child in children) {
      if (child != null) result.add(child);
    }
    return result;
  }

  Object? getSemantic() => semantic;
}

/// Shared packed parse forest symbol node.
class SppfNode {
  final int grammarSymbol;
  final int leftExtent;
  final int rightExtent;
  final List<SppfPacked> packs = [];
  Object? astForest;

  SppfNode(this.grammarSymbol, this.leftExtent, this.rightExtent);

  int getGrammarSymbol() => grammarSymbol;
  int getLeftExtent() => leftExtent;
  int getRightExtent() => rightExtent;
  List<SppfPacked> getPacks() => packs;
  Object? getAstForest() => astForest;
}
