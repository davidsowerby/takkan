import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'preceptItem.g.dart';

/// Most of these values are generated during the [PScript.init] process, and are consequently not
/// stored as part of the JSON output of the script.
///
/// The only one included in the JSON output is [_id]
///
/// There are three levels of id, used primarily for testing.
/// - [_id] just records manually set ids, and this is stored with th rest of the script. Some sub-classes
/// may set this to something like a caption, if no id is explicitly provided
/// - [_uid] is populated by the [PScript.init] process, using the [_id] if one has been set. If not, one is
/// auto-generated to ensure a [_uid] unique within its sibling group.
/// - [_debugId] is constructed by the [PScript.init] process to provide a hierarchical 'path', so the
/// location of any particular [PreceptItem] can be identified via its parent chain. This also
/// becomes the Widget key of the item's associated Widget. This is not stored as JSON.
///
/// These are also generated during the [PScript.init] process, and also used within the construction
/// of ids.
///
/// - [_parent] is the parent PreceptItem within this script
/// - [_index] is child index within a [_parent] where relevant.  Set to 0 if the parent only has one
/// child
//
@JsonSerializable(nullable: true, explicitToJson: true)
class PreceptItem {
  final String _id;
  @JsonKey(ignore: true)
  String uid;
  @JsonKey(ignore: true)
  String _debugId;
  @JsonKey(ignore: true)
  PreceptItem _parent;
  @JsonKey(ignore: true)
  int _index;

  PreceptItem({String id}) : _id = id;

  factory PreceptItem.fromJson(Map<String, dynamic> json) => _$PreceptItemFromJson(json);

  Map<String, dynamic> toJson() => _$PreceptItemToJson(this);

  /// Used for Widget and Functional testing.  This also becomes the Widget key in [Page], [Part] and [Panel] instances
  /// The [PScript.init] method ensures that this key is unique, or will flag an error if it cannot resolve it.
  String get debugId => _debugId;
  PreceptItem get parent => _parent;

  doInit(PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    _parent = parent;
    _index = index;

    if (_id == null || _id.isEmpty) {
      if (useCaptionsAsIds) {
        uid = idAlternative;
      }
      if (uid == null || uid.isEmpty) {
        final type = _widgetTypeFromPreceptType();
        uid = "$type:$index";
      }
      /// PScript cannot call on parent - it does not have one
      if (this is PScript) {
        _debugId = uid;
      }else{
        _debugId = "${_parent.debugId}-$uid";
      }
    } else {
      uid = _id;
      _debugId = "${_parent.debugId}-$uid";
    }
  }

  String get idAlternative => null;

  _widgetTypeFromPreceptType() {
    return this.runtimeType.toString().replaceFirst('P', '');
  }

  void doValidate(List<ValidationMessage> messages) {}

  int get index => _index;
}
