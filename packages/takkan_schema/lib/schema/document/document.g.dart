// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      fields: const FieldMapConverter()
          .fromJson(json['fields'] as Map<String, dynamic>),
      documentType:
          $enumDecodeNullable(_$DocumentTypeEnumMap, json['documentType']) ??
              DocumentType.standard,
      permissions: json['permissions'] == null
          ? null
          : Permissions.fromJson(json['permissions'] as Map<String, dynamic>),
      queries: (json['queries'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Query.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'queries': instance.queries.map((k, e) => MapEntry(k, e.toJson())),
      'permissions': instance.permissions.toJson(),
      'documentType': _$DocumentTypeEnumMap[instance.documentType]!,
      'fields': const FieldMapConverter().toJson(instance.fields),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.standard: 'standard',
  DocumentType.versioned: 'versioned',
};

DocumentDiff _$DocumentDiffFromJson(Map<String, dynamic> json) => DocumentDiff(
      addFields: json['addFields'] == null
          ? const {}
          : const FieldMapConverter()
              .fromJson(json['addFields'] as Map<String, dynamic>),
      removeFields: (json['removeFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      amendFields: (json['amendFields'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, FieldDiff<dynamic>.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      permissions: json['permissions'] == null
          ? null
          : PermissionsDiff.fromJson(
              json['permissions'] as Map<String, dynamic>),
      addQueries: (json['addQueries'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Query.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      removeQueries: (json['removeQueries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      amendQueries: (json['amendQueries'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, QueryDiff.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$DocumentDiffToJson(DocumentDiff instance) =>
    <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'addQueries': instance.addQueries.map((k, e) => MapEntry(k, e.toJson())),
      'addFields': const FieldMapConverter().toJson(instance.addFields),
      'removeFields': instance.removeFields,
      'removeQueries': instance.removeQueries,
      'amendFields':
          instance.amendFields.map((k, e) => MapEntry(k, e.toJson())),
      'amendQueries':
          instance.amendQueries.map((k, e) => MapEntry(k, e.toJson())),
    };
