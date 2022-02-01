// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_selector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldSelector _$FieldSelectorFromJson(Map<String, dynamic> json) =>
    FieldSelector(
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allFields: json['allFields'] as bool? ?? false,
      includeMetaFields: json['includeMetaFields'] as bool? ?? false,
      metaFields: (json['metaFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['createdAt', 'updatedAt'],
      excludeFields: (json['excludeFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FieldSelectorToJson(FieldSelector instance) =>
    <String, dynamic>{
      'metaFields': instance.metaFields,
      'fields': instance.fields,
      'allFields': instance.allFields,
      'includeMetaFields': instance.includeMetaFields,
      'excludeFields': instance.excludeFields,
    };
