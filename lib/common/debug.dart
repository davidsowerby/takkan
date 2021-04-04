import 'package:flutter/foundation.dart';
import 'package:precept_script/common/script/preceptItem.dart';

class DebugNode {
  final PreceptItem item;
  final List<DebugNode> children;
  DebugNode parent;

  DebugNode(this.item, this.children) {
    for (DebugNode child in children) {
      child.parent = this;
    }
  }

  /// Returns the debugId of the parent of node with debug node of [id]
  DebugNode parentOf({@required String debugId}) {
    assert(debugId != null);
    final DebugNode selectedNode = nodeWithId(debugId);
    if(selectedNode != null){
      return selectedNode.parent;
    }
    return null;
  }

  bool hasDebugId(String debugId) => item.debugId == debugId;

  DebugNode nodeWithId(String debugId) {
    if (this.hasDebugId(debugId)) {
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
