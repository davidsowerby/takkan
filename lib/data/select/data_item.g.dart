// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocByFunction _$DocByFunctionFromJson(Map<String, dynamic> json) =>
    DocByFunction(
      cloudFunctionName: json['cloudFunctionName'] as String,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DocByFunctionToJson(DocByFunction instance) =>
    <String, dynamic>{
      'params': instance.params,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
    };

DocByFilter _$DocByFilterFromJson(Map<String, dynamic> json) => DocByFilter(
      queryScript: json['script'] as String? ?? '',
      name: json['name'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DocByFilterToJson(DocByFilter instance) =>
    <String, dynamic>{
      'script': instance.queryScript,
      'name': instance.name,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
    };

DocByGQL _$DocByGQLFromJson(Map<String, dynamic> json) => DocByGQL(
      script: json['script'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DocByGQLToJson(DocByGQL instance) => <String, dynamic>{
      'script': instance.script,
      'liveConnect': instance.liveConnect,
      'name': instance.name,
      'caption': instance.caption,
    };
