import 'package:json_annotation/json_annotation.dart';

part 'document_id.g.dart';

/// Standardised document reference, to uniquely identify a document
/// Back4App (ParseServer) maps directly on to this, where [documentClass] is a Parse Server Class
/// Other implementations may be added later.  For example, for Firebase (not implemented yet):
/// - a [DocumentId] maps to a DocumentReference
/// - [documentClass] maps to a Collection
/// - [objectId] maps to id in a DocumentReference
@JsonSerializable(explicitToJson: true)
class DocumentId {
  /// The path to the document, but not including the [objectId]
  final String documentClass;

  final String objectId;

  const DocumentId({required this.documentClass, required this.objectId});

  factory DocumentId.fromJson(Map<String, dynamic> json) =>
      _$DocumentIdFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentIdToJson(this);

  @JsonKey(ignore: true)
  String get fullReference => "$documentClass:$objectId";

  @override
  bool operator ==(other) {
    return (other is DocumentId) &&
        other.documentClass == documentClass &&
        other.objectId == objectId;
  }
}
