// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataItem _$DataItemFromJson(Map<String, dynamic> json) => DataItem(
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemToJson(DataItem instance) => <String, dynamic>{
      'liveConnect': instance.liveConnect,
      'name': instance.name,
      'caption': instance.caption,
    };

DataItemById _$DataItemByIdFromJson(Map<String, dynamic> json) => DataItemById(
      objectId: json['objectId'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$DataItemByIdToJson(DataItemById instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'liveConnect': instance.liveConnect,
      'name': instance.name,
      'caption': instance.caption,
    };

DataItemByFunction _$DataItemByFunctionFromJson(Map<String, dynamic> json) =>
    DataItemByFunction(
      cloudFunctionName: json['cloudFunctionName'] as String,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemByFunctionToJson(DataItemByFunction instance) =>
    <String, dynamic>{
      'params': instance.params,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
    };

DataItemByFilter _$DataItemByFilterFromJson(Map<String, dynamic> json) =>
    DataItemByFilter(
      script: json['script'] as String,
      name: json['name'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemByFilterToJson(DataItemByFilter instance) =>
    <String, dynamic>{
      'script': instance.script,
      'name': instance.name,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
    };

DataItemByGQL _$DataItemByGQLFromJson(Map<String, dynamic> json) =>
    DataItemByGQL(
      script: json['script'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataItemByGQLToJson(DataItemByGQL instance) =>
    <String, dynamic>{
      'script': instance.script,
      'liveConnect': instance.liveConnect,
      'name': instance.name,
      'caption': instance.caption,
    };
