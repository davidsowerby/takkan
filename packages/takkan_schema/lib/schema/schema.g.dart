// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchemaSet _$SchemaSetFromJson(Map<String, dynamic> json) => SchemaSet(
      baseVersion: Schema.fromJson(json['baseVersion'] as Map<String, dynamic>),
      diffs: (json['diffs'] as List<dynamic>?)
          ?.map((e) => SchemaDiff.fromJson(e as Map<String, dynamic>))
          .toList(),
      schemaName: json['schemaName'] as String,
    );

Map<String, dynamic> _$SchemaSetToJson(SchemaSet instance) => <String, dynamic>{
      'baseVersion': instance.baseVersion.toJson(),
      'schemaName': instance.schemaName,
      'diffs': instance.diffs.map((e) => e.toJson()).toList(),
    };

SchemaDiff _$SchemaDiffFromJson(Map<String, dynamic> json) => SchemaDiff(
      addDocuments: (json['addDocuments'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Document.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      removeDocuments: (json['removeDocuments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      amendDocuments: (json['amendDocuments'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, DocumentDiff.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      readOnly: json['readOnly'] as bool?,
      version: Version.fromJson(json['version'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SchemaDiffToJson(SchemaDiff instance) =>
    <String, dynamic>{
      'addDocuments':
          instance.addDocuments.map((k, e) => MapEntry(k, e.toJson())),
      'removeDocuments': instance.removeDocuments,
      'amendDocuments':
          instance.amendDocuments.map((k, e) => MapEntry(k, e.toJson())),
      'version': instance.version.toJson(),
      'readOnly': instance.readOnly,
    };

Schema _$SchemaFromJson(Map<String, dynamic> json) => Schema(
      documents: (json['documents'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Document.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      version: Version.fromJson(json['version'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
      'version': instance.version.toJson(),
      'documents': instance.documents.map((k, e) => MapEntry(k, e.toJson())),
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
