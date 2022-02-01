// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_delegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGraphQL _$PGraphQLFromJson(Map<String, dynamic> json) => PGraphQL(
      sessionTokenKey: json['sessionTokenKey'] as String,
      graphqlEndpoint: json['graphqlEndpoint'] as String? ?? '/graphql',
      checkHealthOnConnect: json['checkHealthOnConnect'] as bool? ?? false,
    );

Map<String, dynamic> _$PGraphQLToJson(PGraphQL instance) => <String, dynamic>{
      'sessionTokenKey': instance.sessionTokenKey,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'graphqlEndpoint': instance.graphqlEndpoint,
    };
