// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field<MODEL> _$FieldFromJson<MODEL>(Map<String, dynamic> json) => Field<MODEL>(
      required: json['required'] as bool?,
      defaultValue: _$JsonConverterFromJson<Map<String, dynamic>, MODEL>(
          json['defaultValue'], DataTypeConverter<MODEL?>().fromJson),
      validation: json['validation'] as String?,
      isReadOnly: $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']),
      index: $enumDecodeNullable(_$IndexEnumMap, json['index']),
    );

Map<String, dynamic> _$FieldToJson<MODEL>(Field<MODEL> instance) =>
    <String, dynamic>{
      'isReadOnly': _$IsReadOnlyEnumMap[instance.isReadOnly]!,
      'index': _$IndexEnumMap[instance.index]!,
      'validation': instance.validation,
      'required': instance.required,
      'defaultValue': _$JsonConverterToJson<Map<String, dynamic>, MODEL>(
          instance.defaultValue, DataTypeConverter<MODEL?>().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$IsReadOnlyEnumMap = {
  IsReadOnly.yes: 'yes',
  IsReadOnly.no: 'no',
  IsReadOnly.inherited: 'inherited',
};

const _$IndexEnumMap = {
  Index.none: 'none',
  Index.ascending: 'ascending',
  Index.descending: 'descending',
  Index.geo2d: 'geo2d',
  Index.geo2dSphere: 'geo2dSphere',
  Index.geoHaystack: 'geoHaystack',
  Index.text: 'text',
  Index.hashed: 'hashed',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

FieldDiff<MODEL> _$FieldDiffFromJson<MODEL>(Map<String, dynamic> json) =>
    FieldDiff<MODEL>(
      required: json['required'] as bool?,
      defaultValue: _$JsonConverterFromJson<Map<String, dynamic>, MODEL>(
          json['defaultValue'], DataTypeConverter<MODEL?>().fromJson),
      validation: json['validation'] as String?,
      isReadOnly: $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']),
      index: $enumDecodeNullable(_$IndexEnumMap, json['index']),
      removeDefaultValue: json['removeDefaultValue'] as bool? ?? false,
    );

Map<String, dynamic> _$FieldDiffToJson<MODEL>(FieldDiff<MODEL> instance) =>
    <String, dynamic>{
      'removeDefaultValue': instance.removeDefaultValue,
      'index': _$IndexEnumMap[instance.index],
      'validation': instance.validation,
      'required': instance.required,
      'isReadOnly': _$IsReadOnlyEnumMap[instance.isReadOnly],
      'defaultValue': _$JsonConverterToJson<Map<String, dynamic>, MODEL>(
          instance.defaultValue, DataTypeConverter<MODEL?>().toJson),
    };
