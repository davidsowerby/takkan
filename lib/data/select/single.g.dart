// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSingle _$PSingleFromJson(Map<String, dynamic> json) => PSingle(
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PSingleToJson(PSingle instance) => <String, dynamic>{
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

PSingleById _$PSingleByIdFromJson(Map<String, dynamic> json) => PSingleById(
      objectId: json['objectId'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
      tag: json['tag'] as String? ?? 'default',
    );

Map<String, dynamic> _$PSingleByIdToJson(PSingleById instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

PSingleByFunction _$PSingleByFunctionFromJson(Map<String, dynamic> json) =>
    PSingleByFunction(
      cloudFunctionName: json['cloudFunctionName'] as String,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PSingleByFunctionToJson(PSingleByFunction instance) =>
    <String, dynamic>{
      'params': instance.params,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

PSingleByFilter _$PSingleByFilterFromJson(Map<String, dynamic> json) =>
    PSingleByFilter(
      script: json['script'] as String,
      cloudFunctionName: json['cloudFunctionName'] as String?,
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PSingleByFilterToJson(PSingleByFilter instance) =>
    <String, dynamic>{
      'script': instance.script,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

PSingleByGQL _$PSingleByGQLFromJson(Map<String, dynamic> json) => PSingleByGQL(
      script: json['script'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PSingleByGQLToJson(PSingleByGQL instance) =>
    <String, dynamic>{
      'script': instance.script,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };
