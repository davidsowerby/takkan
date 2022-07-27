// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_selector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoData _$NoDataFromJson(Map<String, dynamic> json) => NoData();

Map<String, dynamic> _$NoDataToJson(NoData instance) => <String, dynamic>{};

PageCustom _$PageCustomFromJson(Map<String, dynamic> json) => PageCustom(
      routes:
          (json['routes'] as List<dynamic>).map((e) => e as String).toList(),
      properties: json['properties'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      name: json['name'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String,
    );

Map<String, dynamic> _$PageCustomToJson(PageCustom instance) =>
    <String, dynamic>{
      'routes': instance.routes,
      'properties': instance.properties,
      'name': instance.name,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
    };
