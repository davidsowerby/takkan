// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FObject _$FObjectFromJson(Map<String, dynamic> json) => FObject(
      defaultValue: json['defaultValue'] == null
          ? null
          : JsonObject.fromJson(json['defaultValue'] as Map<String, dynamic>),
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map((e) =>
                  JsonObjectCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FObjectToJson(FObject instance) => <String, dynamic>{
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
