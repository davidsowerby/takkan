// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphqlDelegate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGraphQL _$PGraphQLFromJson(Map<String, dynamic> json) => PGraphQL(
      sessionTokenKey: json['sessionTokenKey'] as String,
      graphqlEndpoint: json['graphqlEndpoint'] as String? ?? '/graphql',
      checkHealthOnConnect: json['checkHealthOnConnect'] as bool? ?? false,
      headerKeys: (json['headerKeys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PGraphQLToJson(PGraphQL instance) => <String, dynamic>{
      'sessionTokenKey': instance.sessionTokenKey,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'headerKeys': instance.headerKeys,
      'graphqlEndpoint': instance.graphqlEndpoint,
    };
