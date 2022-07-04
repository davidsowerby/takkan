// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FString _$FStringFromJson(Map<String, dynamic> json) => FString(
      defaultValue: json['defaultValue'] as String?,
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FStringToJson(FString instance) {
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
