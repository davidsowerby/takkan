// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) =>
    PDataProvider(
      useAuthenticator: json['useAuthenticator'] as bool? ?? false,
      graphQLDelegate: json['graphQLDelegate'] == null
          ? null
          : PGraphQL.fromJson(json['graphQLDelegate'] as Map<String, dynamic>),
      restDelegate: json['restDelegate'] == null
          ? null
          : PRest.fromJson(json['restDelegate'] as Map<String, dynamic>),
      instanceConfig:
          PInstance.fromJson(json['instanceConfig'] as Map<String, dynamic>),
      defaultDelegate:
          $enumDecodeNullable(_$DelegateEnumMap, json['defaultDelegate']) ??
              Delegate.rest,
      signInOptions: json['signInOptions'] == null
          ? const PSignInOptions()
          : PSignInOptions.fromJson(
              json['signInOptions'] as Map<String, dynamic>),
      signIn: json['signIn'] == null
          ? const PSignIn()
          : PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PDataProviderToJson(PDataProvider instance) =>
    <String, dynamic>{
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'instanceConfig': instance.instanceConfig.toJson(),
      'defaultDelegate': _$DelegateEnumMap[instance.defaultDelegate],
      'graphQLDelegate': instance.graphQLDelegate?.toJson(),
      'restDelegate': instance.restDelegate?.toJson(),
      'useAuthenticator': instance.useAuthenticator,
    };

const _$DelegateEnumMap = {
  Delegate.graphQl: 'graphQl',
  Delegate.rest: 'rest',
};

PInstance _$PInstanceFromJson(Map<String, dynamic> json) => PInstance(
      group: json['group'] as String,
      instance: json['instance'] as String?,
    );

Map<String, dynamic> _$PInstanceToJson(PInstance instance) => <String, dynamic>{
      'group': instance.group,
      'instance': instance.instance,
    };

PNoDataProvider _$PNoDataProviderFromJson(Map<String, dynamic> json) =>
    PNoDataProvider();

Map<String, dynamic> _$PNoDataProviderToJson(PNoDataProvider instance) =>
    <String, dynamic>{};
