// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoData _$NoDataFromJson(Map<String, dynamic> json) => NoData(
      caption: json['caption'] as String?,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$NoDataToJson(NoData instance) => <String, dynamic>{
      'caption': instance.caption,
      'tag': instance.tag,
    };

PageCustom _$PageCustomFromJson(Map<String, dynamic> json) => PageCustom(
      routes:
          (json['routes'] as List<dynamic>).map((e) => e as String).toList(),
      properties: json['properties'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      tag: json['tag'] as String? ?? 'default',
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String,
    );

Map<String, dynamic> _$PageCustomToJson(PageCustom instance) =>
    <String, dynamic>{
      'routes': instance.routes,
      'properties': instance.properties,
      'tag': instance.tag,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
    };
