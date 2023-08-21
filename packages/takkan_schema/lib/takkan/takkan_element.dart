// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/debug.dart';
import '../util/walker.dart';

/// The whole of the [Script] structure is a tree, with a single [Script] instance at its root.
///
/// This [TakkanElement] is the base class for the major components of that tree.
///
/// [parent] is the parent [TakkanElement].
///
/// There are there types of id, used to support testing and debugging.
///
/// The [uid] is a unique id within the scope of of a [parent]
/// The [debugId] is a hierarchical 'path' id unique within the scope of a [Script] instance.
/// The hierarchical nature of this key enables means any particular [TakkanElement]
/// can be identified via its parent chain. This also becomes the Widget key of the
/// item's associated Widget, especially useful for functional testing.
///
/// A [_id] is optional and can be set by the constructor [id] parameter.
/// If set it overrides the generated [uid] and become part of the [debugId].
/// It is useful to identify a specific component, or where ambiguity arises from the use of [uid].
/// That is unlikely unless there are two components with the same caption or name.
///
/// - [_childIndex] is the child index within a [_parent] where it is held in a list. Null if not used.
/// - [script] is a reference back to the root [Script] instance.
///
/// All properties except [_id] are generated during the [Script.init] process
/// The only persisted value is [_id] as all the others are generated.
///
/// Use of [Equatable] requires that all fields are final in order to meet
/// the contract of equality and immutability.  However, the descendants
/// of [TakkanElement] are designed for ease of definition by the developer. This
/// means, for example, specifying field names as the keys to a map, but then
/// setting [Field] names during [doInit].  This requires that some fields are
/// 'late' rather than 'final', but for good reason, so the linting has been
/// turned off for this issue in the relevant files.  Equality checks must also
/// therefore not be made until after [doInit] has been called via [Script.init].
///
/// Takkan testing of [Equatable] sub-classes is by ensuring that all properties are
/// listed in [Equatable.props].  However, there are legitimate cases where a property
/// should be excluded from equality comparison.  For test purposes only, an additional
/// getter `List<Object> get excludeProps` can be declared.  This is not an [Equatable]
/// feature, simply an aid for testing in Takkan
// @JsonSerializable(explicitToJson: true)
abstract class TakkanElement extends Equatable with WalkTarget {
  TakkanElement({
    String? id,
  }) : _id = id;

  // factory TakkanElement.fromJson(Map<String, dynamic> json) =>
  //     _$TakkanElementFromJson(json);
  final String? _id;
  @JsonKey(includeToJson: false, includeFromJson: false)
  late String? uid;
 @JsonKey(includeToJson: false, includeFromJson: false)
  late String? _debugId;
 @JsonKey(includeToJson: false, includeFromJson: false)
  late TakkanElement _parent;
 @JsonKey(includeToJson: false, includeFromJson: false)
  late int? _childIndex;

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [
        _id,
      ];

  Map<String, dynamic> toJson();

  /// Used for Widget and Functional testing.  This also becomes the Widget key in [Page], [Part] and [Panel] instances
  /// The [Script.init] method ensures that this key is unique, or will flag an error if it cannot resolve it.
  String? get debugId => _debugId;

  /// This is overridden by an element at the top of the tree to indicate that it does not have a parent
  bool get hasParent => true;

  /// Would be better if we could check whether parent set by calling init, see https://gitlab.com/takkan/takkan_script/-/issues/21
  TakkanElement get parent => _parent;

  String? get pid => _id;

  /// Defines those properties which represent child elements which require the
  /// [Walker] to visit.
  ///
  /// These have to be coded explicitly for each [TakkanElement] sub-class to enable
  /// the [Walker].
  ///
  /// See [ScriptElement] for an example.
  ///
  /// Not all elements are [TakkanElement] sub-classes, hence the returned list is not
  /// typed.
  List<Object> get subElements => [];

  /// Some objects need default values added if not prescribed by the developer.
  /// For example, [Schema] provides default User and Role document definitions
  /// if not provided, and these need to be added before initialisation
  void setDefaults() {}

  void setParent(SetParentWalkerParams params) {
    _parent = params.parent;
  }

  void doInit(InitWalkerParams params) {
    _childIndex = params.index;
    uid = _id;
    String? tUid = uid;

    /// _pid overrides generated [uid]
    if (tUid == null) {
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
    }
    tUid = uid;

    /// if we still don't have a uid, generate one
    if (tUid == null || tUid.isEmpty) {
      final type = runtimeType.toString();
      final String indexStr = (_childIndex == null) ? '' : _childIndex.toString();
      final separator = (_childIndex == null) ? '' : ':';
      uid = '$type$separator$indexStr';
    }

    /// construct hierarchical debugId
    /// Script cannot call on parent - it does not have one
    if (hasParent) {
      _debugId = '${_parent.debugId}.$uid';
    } else {
      _debugId = uid;
    }
  }

  /// Walks through all instances of [TakkanElement] or its sub-classes held within this item.
  /// At each instance, each of the [visitors] [ScriptVisitor.step] is invoked
  @override
  void walk(List<ScriptVisitor> visitors) {
    final collector = VisitorWalkerParams(visitors: visitors);
    final walker = VisitorWalker();
    walker.walk(this, collector);
  }

  /// Defined by sub-classes to use, for example, a caption as part of the id
  /// to make debugging easier
  String? get idAlternative => null;

  void doValidate(ValidationWalkerCollector collector) {}

  int? get childIndex => _childIndex ?? 0;

  DebugNode get debugNode => DebugNode(this, const []);
}
