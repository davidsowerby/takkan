// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocListByFunction _$DocListByFunctionFromJson(Map<String, dynamic> json) =>
    DocListByFunction(
      cloudFunctionName: json['cloudFunctionName'] as String,
      pageLength: json['pageLength'] as int? ?? 20,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DocListByFunctionToJson(DocListByFunction instance) =>
    <String, dynamic>{
      'params': instance.params,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };

DocListByFilter _$DocListByFilterFromJson(Map<String, dynamic> json) =>
    DocListByFilter(
      script: json['script'] as String,
      cloudFunctionName: json['cloudFunctionName'] as String?,
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      caption: json['caption'] as String?,
      pageLength: json['pageLength'] as int? ?? 20,
    );

Map<String, dynamic> _$DocListByFilterToJson(DocListByFilter instance) =>
    <String, dynamic>{
      'script': instance.script,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'pageLength': instance.pageLength,
      'name': instance.name,
      'caption': instance.caption,
    };

DocListByGQL _$DocListByGQLFromJson(Map<String, dynamic> json) => DocListByGQL(
      script: json['script'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      caption: json['caption'] as String?,
      pageLength: json['pageLength'] as int? ?? 20,
    );

Map<String, dynamic> _$DocListByGQLToJson(DocListByGQL instance) =>
    <String, dynamic>{
      'script': instance.script,
      'liveConnect': instance.liveConnect,
      'name': instance.name,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };
