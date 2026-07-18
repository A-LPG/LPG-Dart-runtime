import 'GssEdge.dart';

/// LR state at an input index in a graph-structured stack.
class GssNode {
  final int state;
  final int index;
  final List<GssEdge> edges = [];

  GssNode(this.state, this.index);

  int getState() => state;
  int getIndex() => index;
  List<GssEdge> getEdges() => edges;
}
