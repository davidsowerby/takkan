// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preceptItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreceptItem _$PreceptItemFromJson(Map<String, dynamic> json) {
  return PreceptItem(
    id: json['id'] as String,
    version: json['version'] as int,
  );
}

Map<String, dynamic> _$PreceptItemToJson(PreceptItem instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
    };
