// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSchema _$PSchemaFromJson(Map<String, dynamic> json) {
  return PSchema(
    documents: (json['documents'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e == null ? null : PDocument.fromJson(e as Map<String, dynamic>)),
    ),
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$PSchemaToJson(PSchema instance) => <String, dynamic>{
      'name': instance.name,
      'documents': instance.documents?.map((k, e) => MapEntry(k, e?.toJson())),
    };

PDocument _$PDocumentFromJson(Map<String, dynamic> json) {
  return PDocument(
    fields: const PSchemaElementMapConverter().fromJson(json['fields'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PDocumentToJson(PDocument instance) => <String, dynamic>{
      'fields': const PSchemaElementMapConverter().toJson(instance.fields),
    };
