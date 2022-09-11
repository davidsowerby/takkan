// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FInteger _$FIntegerFromJson(Map<String, dynamic> json) => FInteger(
      defaultValue: json['defaultValue'] as int?,
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map((e) => IntegerCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FIntegerToJson(FInteger instance) => <String, dynamic>{
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
