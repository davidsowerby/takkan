// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restDelegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRest _$PRestFromJson(Map<String, dynamic> json) => PRest(
      documentEndpoint: json['documentEndpoint'] as String? ?? '/classes',
      sessionTokenKey: json['sessionTokenKey'] as String,
      checkHealthOnConnect: json['checkHealthOnConnect'] as bool? ?? false,
      headerKeys: (json['headerKeys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PRestToJson(PRest instance) => <String, dynamic>{
      'sessionTokenKey': instance.sessionTokenKey,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'headerKeys': instance.headerKeys,
      'documentEndpoint': instance.documentEndpoint,
    };
