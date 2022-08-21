// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FBoolean _$FBooleanFromJson(Map<String, dynamic> json) => FBoolean(
      defaultValue: json['defaultValue'] as bool?,
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FBooleanToJson(FBoolean instance) {
  final val = <String, dynamic>{
    'validation': instance.validation,
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue);
  return val;
}
