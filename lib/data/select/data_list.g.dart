// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataList _$DataListFromJson(Map<String, dynamic> json) => DataList(
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      pageLength: json['pageLength'] as int? ?? 20,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataListToJson(DataList instance) => <String, dynamic>{
      'liveConnect': instance.liveConnect,
      'pageLength': instance.pageLength,
      'name': instance.name,
      'caption': instance.caption,
    };

DataListById _$DataListByIdFromJson(Map<String, dynamic> json) => DataListById(
      objectIds:
          (json['objectIds'] as List<dynamic>).map((e) => e as String).toList(),
      liveConnect: json['liveConnect'] as bool? ?? false,
      pageLength: json['pageLength'] as int? ?? 20,
      name: json['name'] as String,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataListByIdToJson(DataListById instance) =>
    <String, dynamic>{
      'objectIds': instance.objectIds,
      'liveConnect': instance.liveConnect,
      'name': instance.name,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };

DataListByFunction _$DataListByFunctionFromJson(Map<String, dynamic> json) =>
    DataListByFunction(
      cloudFunctionName: json['cloudFunctionName'] as String,
      pageLength: json['pageLength'] as int? ?? 20,
      params: json['params'] as Map<String, dynamic>? ?? const {},
      liveConnect: json['liveConnect'] as bool? ?? false,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$DataListByFunctionToJson(DataListByFunction instance) =>
    <String, dynamic>{
      'params': instance.params,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };

DataListByFilter _$DataListByFilterFromJson(Map<String, dynamic> json) =>
    DataListByFilter(
      script: json['script'] as String,
      cloudFunctionName: json['cloudFunctionName'] as String?,
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      caption: json['caption'] as String?,
      pageLength: json['pageLength'] as int? ?? 20,
    );

Map<String, dynamic> _$DataListByFilterToJson(DataListByFilter instance) =>
    <String, dynamic>{
      'script': instance.script,
      'cloudFunctionName': instance.cloudFunctionName,
      'liveConnect': instance.liveConnect,
      'pageLength': instance.pageLength,
      'name': instance.name,
      'caption': instance.caption,
    };

DataListByGQL _$DataListByGQLFromJson(Map<String, dynamic> json) =>
    DataListByGQL(
      script: json['script'] as String,
      liveConnect: json['liveConnect'] as bool? ?? false,
      name: json['name'] as String,
      caption: json['caption'] as String?,
      pageLength: json['pageLength'] as int? ?? 20,
    );

Map<String, dynamic> _$DataListByGQLToJson(DataListByGQL instance) =>
    <String, dynamic>{
      'script': instance.script,
      'liveConnect': instance.liveConnect,
      'name': instance.name,
      'caption': instance.caption,
      'pageLength': instance.pageLength,
    };
