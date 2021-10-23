import 'package:json_annotation/json_annotation.dart';

part 'documentId.g.dart';

/// Standardised document reference, to uniquely identify a document
/// For example, Back4App (ParseServer) uses this as path==clazz and itemId==objectId
/// Other implementations may be added later
@JsonSerializable(explicitToJson: true)
class DocumentId {
  /// The path to the document, but not including the [itemId]
  final String path;

  final String itemId;

  const DocumentId({required this.path, required this.itemId});

  const DocumentId.b4a({required String clazz, required String objectId})
      : path = clazz,
        itemId = objectId;

  factory DocumentId.fromJson(Map<String, dynamic> json) =>
      _$DocumentIdFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentIdToJson(this);

  @JsonKey(ignore: true)
  String get clazz => path;

  @JsonKey(ignore: true)
  String get objectId => itemId;

  @JsonKey(ignore: true)
  String get fullReference => "$path:$itemId";
}
