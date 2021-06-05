// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queryResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PQuerySchema _$PQuerySchemaFromJson(Map<String, dynamic> json) {
  return PQuerySchema(
    documentSchema: json['documentSchema'] as String,
    permissions:
        PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PQuerySchemaToJson(PQuerySchema instance) =>
    <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'documentSchema': instance.documentSchema,
    };
