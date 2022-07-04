// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'double.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FDouble _$FDoubleFromJson(Map<String, dynamic> json) => FDouble(
      defaultValue: (json['defaultValue'] as num?)?.toDouble(),
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FDoubleToJson(FDouble instance) {
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
