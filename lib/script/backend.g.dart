// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBackend _$PBackendFromJson(Map<String, dynamic> json) {
  return PBackend(
    instanceName: json['backendType'] as String,
    connectionData: json['connection'] as Map<String, dynamic>,
    parent:
        json['parent'] == null ? null : PScript.fromJson(json['parent'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PBackendToJson(PBackend instance) => <String, dynamic>{
      'backendType': instance.instanceName,
      'connection': instance.connectionData,
      'parent': instance.parent?.toJson(),
    };
