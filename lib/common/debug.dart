
import 'package:takkan_script/script/precept_item.dart';

class DebugNode {
  final PreceptItem item;
  final List<DebugNode> children;
  DebugNode? parent;

  DebugNode(this.item, this.children) {
    for (DebugNode child in children) {
      child.parent = this;
    }
  }

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
    for (DebugNode child in children) {
      final withId = child.nodeWithId(debugId);
      if (withId != null) {
        return withId;
      }
    }
    return null;
  }
}
