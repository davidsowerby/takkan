// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDataSource _$PDataSourceFromJson(Map<String, dynamic> json) {
  return PDataSource(
    params: json['params'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$PDataSourceToJson(PDataSource instance) =>
    <String, dynamic>{
      'params': instance.params,
    };

PDataGet _$PDataGetFromJson(Map<String, dynamic> json) {
  return PDataGet(
    documentId: json['documentId'] == null
        ? null
        : DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    params: json['params'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$PDataGetToJson(PDataGet instance) => <String, dynamic>{
      'params': instance.params,
      'documentId': instance.documentId?.toJson(),
    };

PDataStream _$PDataStreamFromJson(Map<String, dynamic> json) {
  return PDataStream();
}

Map<String, dynamic> _$PDataStreamToJson(PDataStream instance) =>
    <String, dynamic>{};

DocumentId _$DocumentIdFromJson(Map<String, dynamic> json) {
  return DocumentId(
    path: json['path'] as String,
    itemId: json['itemId'] as String,
  );
}

Map<String, dynamic> _$DocumentIdToJson(DocumentId instance) =>
    <String, dynamic>{
      'path': instance.path,
      'itemId': instance.itemId,
    };
