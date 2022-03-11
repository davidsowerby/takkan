// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PMulti _$PMultiFromJson(Map<String, dynamic> json) => PMulti(
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      pageLength: json['pageLength'] as int? ?? 20,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PMultiToJson(PMulti instance) => <String, dynamic>{
      'liveConnect': instance.liveConnect,
      'pageLength': instance.pageLength,
      'tag': instance.tag,
      'caption': instance.caption,
    };

PMultiById _$PMultiByIdFromJson(Map<String, dynamic> json) => PMultiById(
      objectIds:
          (json['objectIds'] as List<dynamic>).map((e) => e as String).toList(),
      liveConnect: json['liveConnect'] as bool? ?? false,
      pageLength: json['pageLength'] as int? ?? 20,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PMultiByIdToJson(PMultiById instance) =>
    <String, dynamic>{
      'objectIds': instance.objectIds,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };

PMultiByFunction _$PMultiByFunctionFromJson(Map<String, dynamic> json) =>
    PMultiByFunction(
      cloudFunctionName: json['cloudFunctionName'] as String,
      pageLength: json['pageLength'] as int? ?? 20,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PMultiByFunctionToJson(PMultiByFunction instance) =>
    <String, dynamic>{
      'params': instance.params,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };

PMultiByFilter _$PMultiByFilterFromJson(Map<String, dynamic> json) =>
    PMultiByFilter(
      script: json['script'] as String,
      cloudFunctionName: json['cloudFunctionName'] as String?,
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
      pageLength: json['pageLength'] as int? ?? 20,
    );

Map<String, dynamic> _$PMultiByFilterToJson(PMultiByFilter instance) =>
    <String, dynamic>{
      'script': instance.script,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'pageLength': instance.pageLength,
      'tag': instance.tag,
      'caption': instance.caption,
    };

PMultiByGQL _$PMultiByGQLFromJson(Map<String, dynamic> json) => PMultiByGQL(
      script: json['script'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
      pageLength: json['pageLength'] as int? ?? 20,
    );

Map<String, dynamic> _$PMultiByGQLToJson(PMultiByGQL instance) =>
    <String, dynamic>{
      'script': instance.script,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };
