// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PHelp _$PHelpFromJson(Map<String, dynamic> json) {
  return PHelp(
    title: json['title'] as String,
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$PHelpToJson(PHelp instance) => <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
    };
