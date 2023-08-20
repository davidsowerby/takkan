// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataProvider _$DataProviderFromJson(Map<String, dynamic> json) => DataProvider(
      useAuthenticator: json['useAuthenticator'] as bool? ?? false,
      graphQLDelegate: json['graphQLDelegate'] == null
          ? null
          : GraphQL.fromJson(json['graphQLDelegate'] as Map<String, dynamic>),
      restDelegate: json['restDelegate'] == null
          ? const Rest()
          : Rest.fromJson(json['restDelegate'] as Map<String, dynamic>),
      instanceConfig:
          AppInstance.fromJson(json['instanceConfig'] as Map<String, dynamic>),
      defaultDelegate:
          $enumDecodeNullable(_$DelegateEnumMap, json['defaultDelegate']) ??
              Delegate.rest,
      signInOptions: json['signInOptions'] == null
          ? const SignInOptions()
          : SignInOptions.fromJson(
              json['signInOptions'] as Map<String, dynamic>),
      signIn: json['signIn'] == null
          ? const SignIn()
          : SignIn.fromJson(json['signIn'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataProviderToJson(DataProvider instance) =>
    <String, dynamic>{
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'instanceConfig': instance.instanceConfig.toJson(),
      'defaultDelegate': _$DelegateEnumMap[instance.defaultDelegate]!,
      'graphQLDelegate': instance.graphQLDelegate?.toJson(),
      'restDelegate': instance.restDelegate.toJson(),
      'useAuthenticator': instance.useAuthenticator,
    };

const _$DelegateEnumMap = {
  Delegate.graphQl: 'graphQl',
  Delegate.rest: 'rest',
};

AppInstance _$AppInstanceFromJson(Map<String, dynamic> json) => AppInstance(
      group: json['group'] as String,
      instance: json['instance'] as String?,
    );

Map<String, dynamic> _$AppInstanceToJson(AppInstance instance) =>
    <String, dynamic>{
      'group': instance.group,
      'instance': instance.instance,
    };

NullDataProvider _$NullDataProviderFromJson(Map<String, dynamic> json) =>
    NullDataProvider();

Map<String, dynamic> _$NullDataProviderToJson(NullDataProvider instance) =>
    <String, dynamic>{};
