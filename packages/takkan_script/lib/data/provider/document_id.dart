import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_id.g.dart';

/// Standardised document reference, to uniquely identify a document
/// Back4App (ParseServer) maps directly on to this, where [documentClass] is a Parse Server Class
/// Other implementations may be added later.  For example, for Firebase (not implemented yet):
/// - a [DocumentId] maps to a DocumentReference
/// - [documentClass] maps to a Collection
/// - [objectId] maps to id in a DocumentReference
@JsonSerializable(explicitToJson: true)
class DocumentId extends Equatable {
  const DocumentId({required this.documentClass, required this.objectId});

  factory DocumentId.empty() =>
      const DocumentId(documentClass: '', objectId: '');
  factory DocumentId.fromJson(Map<String, dynamic> json) =>
      _$DocumentIdFromJson(json);

  /// The path to the document, but not including the [objectId]
  final String documentClass;

  final String objectId;

  bool get isEmpty => documentClass.isEmpty && objectId.isEmpty;

  Map<String, dynamic> toJson() => _$DocumentIdToJson(this);

 @JsonKey(includeToJson: false, includeFromJson: false)
  String get fullReference => '$documentClass:$objectId';

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [documentClass, objectId];
}
