// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_polygon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FGeoPolygon _$FGeoPolygonFromJson(Map<String, dynamic> json) => FGeoPolygon(
      defaultValue: json['defaultValue'] == null
          ? null
          : GeoPolygon.fromJson(json['defaultValue'] as Map<String, dynamic>),
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map((e) =>
                  GeoPolygonCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FGeoPolygonToJson(FGeoPolygon instance) =>
    <String, dynamic>{
      'isReadOnly': _$IsReadOnlyEnumMap[instance.isReadOnly]!,
      'constraints': instance.constraints.map((e) => e.toJson()).toList(),
      'validation': instance.validation,
      'required': instance.required,
      'defaultValue': instance.defaultValue?.toJson(),
    };

const _$IsReadOnlyEnumMap = {
  IsReadOnly.yes: 'yes',
  IsReadOnly.no: 'no',
  IsReadOnly.inherited: 'inherited',
};
