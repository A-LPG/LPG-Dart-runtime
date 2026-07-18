import 'GssNode.dart';
import 'SppfNode.dart';

/// Predecessor edge in a graph-structured stack.
class GssEdge {
  final GssNode predecessor;
  final int symbol;
  final int location;
  final Object? semantic;
  final SppfNode? sppf;

  GssEdge(this.predecessor, this.symbol, this.location,
      [this.semantic, this.sppf]);

  GssNode getPredecessor() => predecessor;
  int getSymbol() => symbol;
  int getLocation() => location;
  Object? getSemantic() => semantic;
  SppfNode? getSppf() => sppf;
}
