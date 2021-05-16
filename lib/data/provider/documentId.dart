import 'package:json_annotation/json_annotation.dart';

part 'documentId.g.dart';

/// Standardised document reference, which is converted to / from whatever the cloud provider uses, by an implementation of
/// [DocumentIdConverter].
/// For example, Back4App (ParseServer) uses this as path==className and itemId==objectId
@JsonSerializable( explicitToJson: true)
class DocumentId {
  /// The path to the document, but not including the [itemId]
  final String path;

  final String itemId;

  const DocumentId({required this.path, required this.itemId});

  factory DocumentId.fromJson(Map<String, dynamic> json) => _$DocumentIdFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentIdToJson(this);

  String get toKey => "$path:$itemId";
}
