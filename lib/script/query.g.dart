// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGet _$PGetFromJson(Map<String, dynamic> json) {
  return PGet(
    documentId: json['documentId'] == null
        ? null
        : DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    params: json['params'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$PGetToJson(PGet instance) => <String, dynamic>{
      'params': instance.params,
      'documentId': instance.documentId?.toJson(),
    };

PGetStream _$PGetStreamFromJson(Map<String, dynamic> json) {
  return PGetStream(
    documentId: json['documentId'] == null
        ? null
        : DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    params: json['params'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$PGetStreamToJson(PGetStream instance) =>
    <String, dynamic>{
      'params': instance.params,
      'documentId': instance.documentId?.toJson(),
    };
