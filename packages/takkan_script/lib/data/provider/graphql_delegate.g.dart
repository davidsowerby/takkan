// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_delegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphQL _$GraphQLFromJson(Map<String, dynamic> json) => GraphQL(
      graphqlEndpoint: json['graphqlEndpoint'] as String? ?? '/graphql',
      checkHealthOnConnect: json['checkHealthOnConnect'] as bool? ?? false,
    );

Map<String, dynamic> _$GraphQLToJson(GraphQL instance) => <String, dynamic>{
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'graphqlEndpoint': instance.graphqlEndpoint,
    };
