// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataItem _$DataItemFromJson(Map<String, dynamic> json) => DataItem(
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemToJson(DataItem instance) => <String, dynamic>{
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

DataItemById _$DataItemByIdFromJson(Map<String, dynamic> json) => DataItemById(
      objectId: json['objectId'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
      tag: json['tag'] as String? ?? 'default',
    );

Map<String, dynamic> _$DataItemByIdToJson(DataItemById instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

DataItemByFunction _$DataItemByFunctionFromJson(Map<String, dynamic> json) =>
    DataItemByFunction(
      cloudFunctionName: json['cloudFunctionName'] as String,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemByFunctionToJson(DataItemByFunction instance) =>
    <String, dynamic>{
      'params': instance.params,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

DataItemByFilter _$DataItemByFilterFromJson(Map<String, dynamic> json) =>
    DataItemByFilter(
      script: json['script'] as String,
      cloudFunctionName: json['cloudFunctionName'] as String?,
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemByFilterToJson(DataItemByFilter instance) =>
    <String, dynamic>{
      'script': instance.script,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };

DataItemByGQL _$DataItemByGQLFromJson(Map<String, dynamic> json) =>
    DataItemByGQL(
      script: json['script'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      tag: json['tag'] as String? ?? 'default',
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemByGQLToJson(DataItemByGQL instance) =>
    <String, dynamic>{
      'script': instance.script,
      'liveConnect': instance.liveConnect,
      'tag': instance.tag,
      'caption': instance.caption,
    };
