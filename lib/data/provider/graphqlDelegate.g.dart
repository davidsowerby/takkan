// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphqlDelegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGraphQLDelegate _$PGraphQLDelegateFromJson(Map<String, dynamic> json) {
  return PGraphQLDelegate(
    sessionTokenKey: json['sessionTokenKey'] as String,
    graphqlEndpoint: json['graphqlEndpoint'] as String,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
  );
}

Map<String, dynamic> _$PGraphQLDelegateToJson(PGraphQLDelegate instance) =>
    <String, dynamic>{
      'graphqlEndpoint': instance.graphqlEndpoint,
      'sessionTokenKey': instance.sessionTokenKey,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
    };
