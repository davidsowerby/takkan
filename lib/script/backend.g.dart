// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBackend _$PBackendFromJson(Map<String, dynamic> json) {
  return PBackend(
    backendType: json['backendType'] as String,
    connection: json['connection'] as Map<String, dynamic>,
    parent:
        json['parent'] == null ? null : PScript.fromJson(json['parent'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PBackendToJson(PBackend instance) => <String, dynamic>{
      'backendType': instance.backendType,
      'connection': instance.connection,
      'parent': instance.parent?.toJson(),
    };
