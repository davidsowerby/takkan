// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FList _$FListFromJson(Map<String, dynamic> json) => FList(
      defaultValue: json['defaultValue'] as List<dynamic>?,
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FListToJson(FList instance) {
  final val = <String, dynamic>{
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
