// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'double.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FDouble _$FDoubleFromJson(Map<String, dynamic> json) => FDouble(
      defaultValue: (json['defaultValue'] as num?)?.toDouble(),
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map((e) => DoubleCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FDoubleToJson(FDouble instance) => <String, dynamic>{
      'isReadOnly': _$IsReadOnlyEnumMap[instance.isReadOnly]!,
      'constraints': instance.constraints.map((e) => e.toJson()).toList(),
      'validation': instance.validation,
      'required': instance.required,
      'defaultValue': instance.defaultValue,
    };

const _$IsReadOnlyEnumMap = {
  IsReadOnly.yes: 'yes',
  IsReadOnly.no: 'no',
  IsReadOnly.inherited: 'inherited',
};
