// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FInteger _$FIntegerFromJson(Map<String, dynamic> json) => FInteger(
      defaultValue: json['defaultValue'] as int?,
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FIntegerToJson(FInteger instance) {
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
