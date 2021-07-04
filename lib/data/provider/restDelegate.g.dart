// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restDelegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestDelegate _$PRestDelegateFromJson(Map<String, dynamic> json) {
  return PRestDelegate(
    documentEndpoint: json['documentEndpoint'] as String,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    sessionTokenKey: json['sessionTokenKey'] as String,
    headerKeys:
        (json['headerKeys'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$PRestDelegateToJson(PRestDelegate instance) =>
    <String, dynamic>{
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'documentEndpoint': instance.documentEndpoint,
      'sessionTokenKey': instance.sessionTokenKey,
      'headerKeys': instance.headerKeys,
    };
