// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSchema _$PSchemaFromJson(Map<String, dynamic> json) {
  return PSchema(
    documents: (json['documents'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : PDocument.fromJson(e as Map<String, dynamic>)),
    ),
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$PSchemaToJson(PSchema instance) => <String, dynamic>{
      'name': instance.name,
      'documents': instance.documents?.map((k, e) => MapEntry(k, e?.toJson())),
    };

PPermissions _$PPermissionsFromJson(Map<String, dynamic> json) {
  return PPermissions(
    (json['readRoles'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    (json['writeRoles'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$PPermissionsToJson(PPermissions instance) =>
    <String, dynamic>{
      'readRoles': instance.readRoles,
      'writeRoles': instance.writeRoles,
    };

PDocument _$PDocumentFromJson(Map<String, dynamic> json) {
  return PDocument(
    fields: const PSchemaElementMapConverter()
        .fromJson(json['fields'] as Map<String, dynamic>),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    readRequiresAuthentication: json['readRequiresAuthentication'] as bool,
    writeRequiresAuthentication: json['writeRequiresAuthentication'] as bool,
  );
}

Map<String, dynamic> _$PDocumentToJson(PDocument instance) => <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'fields': const PSchemaElementMapConverter().toJson(instance.fields),
      'readRequiresAuthentication': instance.readRequiresAuthentication,
      'writeRequiresAuthentication': instance.writeRequiresAuthentication,
    };

PSchemaSource _$PSchemaSourceFromJson(Map<String, dynamic> json) {
  return PSchemaSource(
    segment: json['segment'] as String,
    instance: json['instance'] as String,
  );
}

Map<String, dynamic> _$PSchemaSourceToJson(PSchemaSource instance) =>
    <String, dynamic>{
      'segment': instance.segment,
      'instance': instance.instance,
    };
