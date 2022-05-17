import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/debug.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/util/visitor.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/validation/message.dart';

part 'takkan_item.g.dart';

/// The whole of the [Script] structure is a tree, with a single [Script] instance at its root.
///
/// This [TakkanItem] is the base class for the major components of that tree.
///
/// [parent] is the parent [TakkanItem].
///
/// There are there types of id, used to support testing and debugging.
///
/// The [uid] is a unique id within the scope of of a [parent]
/// The [debugId] is a hierarchical 'path' id unique within the scope of a [Script] instance.
/// The hierarchical nature of this key enables means any particular [TakkanItem]
/// can be identified via its parent chain. This also becomes the Widget key of the
/// item's associated Widget, especially useful for functional testing.
///
/// A [_id] is optional and can be set by the constructor [id] parameter.
/// If set it overrides the generated [uid] and become part of the [debugId].
/// It is useful to identify a specific component, or where ambiguity arises from the use of [uid].
/// That is unlikely unless there are two components with the same caption or name.
///
/// - [_index] is the child index within a [_parent] where it is held in a list. Null if not used.
/// - [script] is a reference back to the root [Script] instance.
///
/// All properties except [_id] are generated during the [Script.init] process
/// The only persisted value is [_id] as all the others are generated.
///
@JsonSerializable(explicitToJson: true)
class TakkanItem with WalkTarget {
  final String? _id;
  @JsonKey(ignore: true)
  String? uid;
  @JsonKey(ignore: true)
  String? _debugId;
  @JsonKey(ignore: true)
  late TakkanItem _parent;
  @JsonKey(ignore: true)
  int? _index;
  @JsonKey(ignore: true)
  late Script _script;

  TakkanItem({
    String? id,
  }) : _id = id;

  factory TakkanItem.fromJson(Map<String, dynamic> json) =>
      _$TakkanItemFromJson(json);

  Map<String, dynamic> toJson() => _$TakkanItemToJson(this);

  /// Used for Widget and Functional testing.  This also becomes the Widget key in [Page], [Part] and [Panel] instances
  /// The [Script.init] method ensures that this key is unique, or will flag an error if it cannot resolve it.
  String? get debugId => _debugId;

  /// Would be better if we could check whether parent set by calling init, see https://gitlab.com/takkan/takkan_script/-/issues/21
  TakkanItem get parent => _parent;

  String? get pid => _id;

  Script get script => _script;

  /// Defines those properties which represent child elements which require the
  /// [Walker] to visit.
  ///
  /// These have to be coded explicitly for each [TakkanItem] sub-class to enable
  /// the [Walker].
  ///
  /// See [Common] for an example.
  ///
  /// Not all elements are [TakkanItem] sub-classes, hence the returned list is not
  /// typed.
  List<dynamic> get subElements => [];

  setParent(SetParentWalkerParams params) {
    _parent = params.parent;
    _script = params.script;
  }

  doInit(InitWalkerParams params) {
    _index = params.index;
    uid = _id;

    /// _pid overrides generated [uid]
    if (uid == null) {
      /// Use caption (or other specified alternative) if required
      if (params.useCaptionsAsIds) {
        final s = idAlternative;
        if (s != null) {
          uid = idAlternative;
          if (s.endsWith(':')) {
            uid = '$s${params.name}';
          }
        }
      }

      /// if we still don't have a uid, generate one
      if (uid == null || uid?.length == 0) {
        final type = runtimeType.toString();
        final String indexStr = (_index == null) ? '' : _index.toString();
        final separator = (_index == null) ? '' : ':';
        uid = '$type$separator$indexStr';
      }
    }

    /// construct hierarchical debugId
    /// PScript cannot call on parent - it does not have one
    if (parent is NullTakkanItem) {
      _debugId = uid;
    } else {
      _debugId = "${_parent.debugId}.$uid";
    }
  }

  /// Walks through all instances of [TakkanItem] or its sub-classes held within this item.
  /// At each instance, the each of the [visitors] [ScriptVisitor.step] is invoked
  @override
  walk(List<ScriptVisitor> visitors) {
    final collector = VisitorWalkerParams(visitors: visitors);
    final walker = VisitorWalker();
    walker.walk(this, collector);
  }

  /// Defined by sub-classes to use, for example, a caption as part of the id
  /// to make debugging easier
  String? get idAlternative => null;

  void doValidate(ValidationWalkerCollector collector) {}

  int? get index => _index ?? 0;

  DebugNode get debugNode => DebugNode(this, const []);
}

abstract class WalkTarget {
  walk(List<ScriptVisitor> visitors) {
    for (ScriptVisitor visitor in visitors) {
      visitor.step(this);
    }
  }
}

abstract class WalkerParams {
  const WalkerParams();
}

abstract class Walker<PARAMS extends WalkerParams, TRACK> {
  final List<TRACK> tracker = List.empty(growable: true);

  walk(TakkanItem root, PARAMS params) {
    final itemResult = _processItem(root, params);
    if (itemResult is List) {
      tracker.addAll(List<TRACK>.from(itemResult));
    } else {
      tracker.add(itemResult);
    }
    cascade(root, params);
  }

  TRACK _processItem(TakkanItem root, PARAMS params);

  void cascade(TakkanItem item, PARAMS params) {
    for (Object child in item.subElements) {
      if (child is TakkanItem) {
        walk(child, childParams(item, params));
      } else {
        if (child is List) {
          int count = 0;
          for (Object entry in child) {
            if (entry is TakkanItem) {
              walk(entry, childParams(item, params, index: count));
            }
            count++;
          }
        } else {
          if (child is Map) {
            for (MapEntry entry in child.entries) {
              if (entry.value is TakkanItem) {
                walk(entry.value, childParams(item, params, name: entry.key));
              }
            }
          }
        }
      }
    }
  }

  /// Override this if you need to modify the params as they are passed down the tree.
  /// See [InitWalker] for an example.
  PARAMS childParams(TakkanItem root, PARAMS params,
      {int? index, String? name}) {
    return params;
  }
}

class InitWalkerParams extends WalkerParams {
  final int? index;
  final String? name;
  final bool useCaptionsAsIds;

  const InitWalkerParams({this.name,
      this.index,
      this.useCaptionsAsIds = true});
}

class InitWalker extends Walker<InitWalkerParams, String> {
  @override
  String _processItem(TakkanItem item, InitWalkerParams params) {
    item.doInit(params);
    return item.debugId!;
  }

  @override
  InitWalkerParams childParams(TakkanItem parentItem, InitWalkerParams params,
      {int? index, String? name}) {
    return InitWalkerParams(
      name: name,
      index: index,
      useCaptionsAsIds: params.useCaptionsAsIds,
    );
  }
}

class SetParentWalkerParams extends WalkerParams {
  final Script script;
  final TakkanItem parent;

  const SetParentWalkerParams({
    required this.script,
    required this.parent,
  });
}

class SetParentWalker extends Walker<SetParentWalkerParams, String> {
  @override
  String _processItem(TakkanItem item, SetParentWalkerParams params) {
    item.setParent(params);
    return item.runtimeType.toString();
  }

  @override
  SetParentWalkerParams childParams(
      TakkanItem parentItem, SetParentWalkerParams params,
      {int? index, String? name}) {
    return SetParentWalkerParams(
      script: params.script,
      parent: parentItem,
    );
  }
}

class VisitorWalker extends Walker<VisitorWalkerParams, String> {
  @override
  String _processItem(TakkanItem root, VisitorWalkerParams params) {
    for (ScriptVisitor visitor in params.visitors) {
      visitor.step(root);
    }
    return root.debugId!;
  }
}

class ValidationWalker extends Walker<ValidationWalkerCollector, int> {
  @override
  int _processItem(TakkanItem root, ValidationWalkerCollector params) {
    root.doValidate(params);
    return params.messages.length;
  }
}

class ValidationWalkerCollector extends WalkerParams {
  final List<ValidationMessage> messages = [];
}

class EmptyWalkerParams extends WalkerParams {}

class VisitorWalkerParams extends WalkerParams {
  final List<ScriptVisitor> visitors;

  const VisitorWalkerParams({required this.visitors});
}
