// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documentId.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentId _$DocumentIdFromJson(Map<String, dynamic> json) {
  return DocumentId(
    path: json['path'] as String,
    itemId: json['itemId'] as String,
  );
}

Map<String, dynamic> _$DocumentIdToJson(DocumentId instance) => <String, dynamic>{
      'path': instance.path,
      'itemId': instance.itemId,
    };
