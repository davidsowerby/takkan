// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSchema _$PSchemaFromJson(Map<String, dynamic> json) {
  return PSchema(
    documents: (json['documents'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, PDocument.fromJson(e as Map<String, dynamic>)),
    ),
    name: json['name'] as String,
    queries: (json['queries'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, PQuerySchema.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$PSchemaToJson(PSchema instance) => <String, dynamic>{
      'name': instance.name,
      'queries': instance.queries.map((k, e) => MapEntry(k, e.toJson())),
      'documents': instance.documents.map((k, e) => MapEntry(k, e.toJson())),
    };

PPermissions _$PPermissionsFromJson(Map<String, dynamic> json) {
  return PPermissions(
    readRoles:
        (json['readRoles'] as List<dynamic>).map((e) => e as String).toList(),
    updateRoles:
        (json['updateRoles'] as List<dynamic>).map((e) => e as String).toList(),
    createRoles:
        (json['createRoles'] as List<dynamic>).map((e) => e as String).toList(),
    deleteRoles:
        (json['deleteRoles'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$PPermissionsToJson(PPermissions instance) =>
    <String, dynamic>{
      'readRoles': instance.readRoles,
      'updateRoles': instance.updateRoles,
      'createRoles': instance.createRoles,
      'deleteRoles': instance.deleteRoles,
    };

PDocument _$PDocumentFromJson(Map<String, dynamic> json) {
  return PDocument(
    fields: const PSchemaElementMapConverter()
        .fromJson(json['fields'] as Map<String, dynamic>),
    permissions:
        PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PDocumentToJson(PDocument instance) => <String, dynamic>{
      'permissions': instance.permissions.toJson(),
      'fields': const PSchemaElementMapConverter().toJson(instance.fields),
    };

PSchemaSource _$PSchemaSourceFromJson(Map<String, dynamic> json) {
  return PSchemaSource(
    segment: json['segment'] as String,
    instance: json['instance'] as String,
    id: json['id'] as String?,
    version: json['version'] as int,
  );
}

Map<String, dynamic> _$PSchemaSourceToJson(PSchemaSource instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'segment': instance.segment,
      'instance': instance.instance,
    };
