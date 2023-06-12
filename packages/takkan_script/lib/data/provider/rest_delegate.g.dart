// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_delegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rest _$RestFromJson(Map<String, dynamic> json) => Rest(
      documentEndpoint: json['documentEndpoint'] as String? ?? '/classes',
      checkHealthOnConnect: json['checkHealthOnConnect'] as bool? ?? false,
    );

Map<String, dynamic> _$RestToJson(Rest instance) => <String, dynamic>{
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'documentEndpoint': instance.documentEndpoint,
    };
