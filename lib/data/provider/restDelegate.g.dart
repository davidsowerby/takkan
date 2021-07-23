// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restDelegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRest _$PRestFromJson(Map<String, dynamic> json) {
  return PRest(
    documentEndpoint: json['documentEndpoint'] as String,
    sessionTokenKey: json['sessionTokenKey'] as String,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    headerKeys:
        (json['headerKeys'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$PRestToJson(PRest instance) => <String, dynamic>{
      'sessionTokenKey': instance.sessionTokenKey,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'headerKeys': instance.headerKeys,
      'documentEndpoint': instance.documentEndpoint,
    };
