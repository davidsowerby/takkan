// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FString _$FStringFromJson(Map<String, dynamic> json) => FString(
      defaultValue: json['defaultValue'] as String?,
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map((e) => StringCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FStringToJson(FString instance) => <String, dynamic>{
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
