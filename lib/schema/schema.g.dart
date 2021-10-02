// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSchema _$PSchemaFromJson(Map<String, dynamic> json) => PSchema(
      documents: (json['documents'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, PDocument.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      name: json['name'] as String,
      namedQueries: (json['namedQueries'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, const PQueryConverter().fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$PSchemaToJson(PSchema instance) => <String, dynamic>{
      'name': instance.name,
      'namedQueries': instance.namedQueries
          .map((k, e) => MapEntry(k, const PQueryConverter().toJson(e))),
      'documents': instance.documents.map((k, e) => MapEntry(k, e.toJson())),
    };

PPermissions _$PPermissionsFromJson(Map<String, dynamic> json) => PPermissions(
      isPublic: (json['isPublic'] as List<dynamic>?)
              ?.map((e) => _$enumDecode(_$AccessMethodEnumMap, e))
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

Map<String, dynamic> _$PPermissionsToJson(PPermissions instance) =>
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

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

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

PDocument _$PDocumentFromJson(Map<String, dynamic> json) => PDocument(
      fields: const PSchemaFieldMapConverter()
          .fromJson(json['fields'] as Map<String, dynamic>),
      documentType:
          _$enumDecodeNullable(_$PDocumentTypeEnumMap, json['documentType']) ??
              PDocumentType.standard,
      permissions: json['permissions'] == null
          ? const PPermissions()
          : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PDocumentToJson(PDocument instance) {
  final val = <String, dynamic>{
    'permissions': instance.permissions.toJson(),
    'documentType': _$PDocumentTypeEnumMap[instance.documentType],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'fields', const PSchemaFieldMapConverter().toJson(instance.fields));
  return val;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$PDocumentTypeEnumMap = {
  PDocumentType.standard: 'standard',
  PDocumentType.versioned: 'versioned',
};

PSchemaSource _$PSchemaSourceFromJson(Map<String, dynamic> json) =>
    PSchemaSource(
      segment: json['segment'] as String,
      instance: json['instance'] as String,
      version: json['version'] as int,
    );

Map<String, dynamic> _$PSchemaSourceToJson(PSchemaSource instance) =>
    <String, dynamic>{
      'version': instance.version,
      'segment': instance.segment,
      'instance': instance.instance,
    };
