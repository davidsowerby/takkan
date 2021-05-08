// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queryResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PQueryResult _$PQueryResultFromJson(Map<String, dynamic> json) {
  return PQueryResult(
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PQueryResultToJson(PQueryResult instance) =>
    <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
    };
