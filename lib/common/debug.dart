
import '../script/takkan_item.dart';

class DebugNode {

  DebugNode(this.item, this.children) {
    for (final DebugNode child in children) {
      child.parent = this;
    }
  }
  final TakkanItem item;
  final List<DebugNode> children;
  DebugNode? parent;

  /// Returns the debugId of the parent of node with debug node of [id]
  DebugNode? parentOf({required String debugId}) {
    final DebugNode? selectedNode = nodeWithId(debugId);
    return selectedNode?.parent;
  }

  bool hasDebugId(String debugId) => item.debugId == debugId;

  DebugNode? nodeWithId(String debugId) {
    if (hasDebugId(debugId)) {
      return this;
    }
    for (final DebugNode child in children) {
      final withId = child.nodeWithId(debugId);
      if (withId != null) {
        return withId;
      }
    }
    return null;
  }
}
