// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPageCustom _$PPageCustomFromJson(Map<String, dynamic> json) => PPageCustom(
      routes:
          (json['routes'] as List<dynamic>).map((e) => e as String).toList(),
      properties: json['properties'] as Map<String, dynamic>? ?? const {},
      tag: json['tag'] as String? ?? 'default',
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String,
    );

Map<String, dynamic> _$PPageCustomToJson(PPageCustom instance) =>
    <String, dynamic>{
      'routes': instance.routes,
      'properties': instance.properties,
      'tag': instance.tag,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
    };
