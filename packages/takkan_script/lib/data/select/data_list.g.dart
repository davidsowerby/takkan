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

DocListByQuery _$DocListByQueryFromJson(Map<String, dynamic> json) =>
    DocListByQuery(
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
      pageLength: json['pageLength'] as int? ?? 20,
      queryName: json['queryName'] as String,
    );

Map<String, dynamic> _$DocListByQueryToJson(DocListByQuery instance) =>
    <String, dynamic>{
      'liveConnect': instance.liveConnect,
      'pageLength': instance.pageLength,
      'caption': instance.caption,
      'queryName': instance.queryName,
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
