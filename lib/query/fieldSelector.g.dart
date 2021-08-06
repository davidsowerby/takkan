// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fieldSelector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldSelector _$FieldSelectorFromJson(Map<String, dynamic> json) {
  return FieldSelector(
    fields: (json['fields'] as List<dynamic>).map((e) => e as String).toList(),
    allFields: json['allFields'] as bool,
    includeMetaFields: json['includeMetaFields'] as bool,
    metaFields:
        (json['metaFields'] as List<dynamic>).map((e) => e as String).toList(),
    excludeFields: (json['excludeFields'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$FieldSelectorToJson(FieldSelector instance) =>
    <String, dynamic>{
      'metaFields': instance.metaFields,
      'fields': instance.fields,
      'allFields': instance.allFields,
      'includeMetaFields': instance.includeMetaFields,
      'excludeFields': instance.excludeFields,
    };
