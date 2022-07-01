// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schema _$SchemaFromJson(Map<String, dynamic> json) => Schema(
      documents: (json['documents'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Document.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      name: json['name'] as String,
      version: Version.fromJson(json['version'] as Map<String, dynamic>),
      namedQueries: (json['namedQueries'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Query.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
      'name': instance.name,
      'namedQueries':
          instance.namedQueries.map((k, e) => MapEntry(k, e.toJson())),
      'version': instance.version.toJson(),
      'documents': instance.documents.map((k, e) => MapEntry(k, e.toJson())),
    };

Permissions _$PermissionsFromJson(Map<String, dynamic> json) => Permissions(
      isPublic: (json['isPublic'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AccessMethodEnumMap, e))
              .toList() ??
          const [],
      readRoles: (json['readRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      writeRoles: (json['writeRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updateRoles: (json['updateRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createRoles: (json['createRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deleteRoles: (json['deleteRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      addFieldRoles: (json['addFieldRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      getRoles: (json['getRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      findRoles: (json['findRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      countRoles: (json['countRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PermissionsToJson(Permissions instance) =>
    <String, dynamic>{
      'isPublic':
          instance.isPublic.map((e) => _$AccessMethodEnumMap[e]).toList(),
      'readRoles': instance.readRoles,
      'writeRoles': instance.writeRoles,
      'addFieldRoles': instance.addFieldRoles,
      'updateRoles': instance.updateRoles,
      'createRoles': instance.createRoles,
      'deleteRoles': instance.deleteRoles,
      'getRoles': instance.getRoles,
      'findRoles': instance.findRoles,
      'countRoles': instance.countRoles,
    };

const _$AccessMethodEnumMap = {
  AccessMethod.all: 'all',
  AccessMethod.read: 'read',
  AccessMethod.get: 'get',
  AccessMethod.find: 'find',
  AccessMethod.count: 'count',
  AccessMethod.write: 'write',
  AccessMethod.create: 'create',
  AccessMethod.update: 'update',
  AccessMethod.delete: 'delete',
  AccessMethod.addField: 'addField',
};

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      fields: const SchemaFieldMapConverter()
          .fromJson(json['fields'] as Map<String, dynamic>),
      documentType:
          $enumDecodeNullable(_$DocumentTypeEnumMap, json['documentType']) ??
              DocumentType.standard,
      permissions: json['permissions'] == null
          ? const Permissions()
          : Permissions.fromJson(json['permissions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DocumentToJson(Document instance) {
  final val = <String, dynamic>{
    'permissions': instance.permissions.toJson(),
    'documentType': _$DocumentTypeEnumMap[instance.documentType],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'fields', const SchemaFieldMapConverter().toJson(instance.fields));
  return val;
}

const _$DocumentTypeEnumMap = {
  DocumentType.standard: 'standard',
  DocumentType.versioned: 'versioned',
};

SchemaSource _$SchemaSourceFromJson(Map<String, dynamic> json) => SchemaSource(
      group: json['group'] as String,
      instance: json['instance'] as String,
    );

Map<String, dynamic> _$SchemaSourceToJson(SchemaSource instance) =>
    <String, dynamic>{
      'group': instance.group,
      'instance': instance.instance,
    };
