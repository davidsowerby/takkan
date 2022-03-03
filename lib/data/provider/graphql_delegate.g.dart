// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_delegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGraphQL _$PGraphQLFromJson(Map<String, dynamic> json) => PGraphQL(
      graphqlEndpoint: json['graphqlEndpoint'] as String? ?? '/graphql',
      checkHealthOnConnect: json['checkHealthOnConnect'] as bool? ?? false,
    );

Map<String, dynamic> _$PGraphQLToJson(PGraphQL instance) => <String, dynamic>{
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'graphqlEndpoint': instance.graphqlEndpoint,
    };
