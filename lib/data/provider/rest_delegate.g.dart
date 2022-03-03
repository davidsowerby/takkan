// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_delegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRest _$PRestFromJson(Map<String, dynamic> json) => PRest(
      documentEndpoint: json['documentEndpoint'] as String? ?? '/classes',
      checkHealthOnConnect: json['checkHealthOnConnect'] as bool? ?? false,
    );

Map<String, dynamic> _$PRestToJson(PRest instance) => <String, dynamic>{
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'documentEndpoint': instance.documentEndpoint,
    };
