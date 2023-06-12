// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FIntegerList _$FIntegerListFromJson(Map<String, dynamic> json) => FIntegerList(
      defaultValue: (json['defaultValue'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map((e) => ListIntCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
    );

Map<String, dynamic> _$FIntegerListToJson(FIntegerList instance) =>
    <String, dynamic>{
      'isReadOnly': _$IsReadOnlyEnumMap[instance.isReadOnly]!,
      'constraints': instance.constraints.map((e) => e.toJson()).toList(),
      'required': instance.required,
      'defaultValue': instance.defaultValue,
    };

const _$IsReadOnlyEnumMap = {
  IsReadOnly.yes: 'yes',
  IsReadOnly.no: 'no',
  IsReadOnly.inherited: 'inherited',
};
