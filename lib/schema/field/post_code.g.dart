// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FPostCode _$FPostCodeFromJson(Map<String, dynamic> json) => FPostCode(
      defaultValue: json['defaultValue'] == null
          ? null
          : PostCode.fromJson(json['defaultValue'] as Map<String, dynamic>),
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map(
                  (e) => PostCodeCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FPostCodeToJson(FPostCode instance) => <String, dynamic>{
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
