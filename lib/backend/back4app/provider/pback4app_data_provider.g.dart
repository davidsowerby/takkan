// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pback4app_data_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBack4AppDataProvider _$PBack4AppDataProviderFromJson(
        Map<String, dynamic> json) =>
    PBack4AppDataProvider(
      signInOptions: json['signInOptions'] == null
          ? const PSignInOptions()
          : PSignInOptions.fromJson(
              json['signInOptions'] as Map<String, dynamic>),
      signIn: json['signIn'] == null
          ? const PSignIn()
          : PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
      configSource:
          PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
      restDelegate: json['restDelegate'] == null
          ? null
          : PRest.fromJson(json['restDelegate'] as Map<String, dynamic>),
      useAuthenticator: json['useAuthenticator'] as bool? ?? true,
    );

Map<String, dynamic> _$PBack4AppDataProviderToJson(
        PBack4AppDataProvider instance) =>
    <String, dynamic>{
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'configSource': instance.configSource.toJson(),
      'restDelegate': instance.restDelegate?.toJson(),
      'useAuthenticator': instance.useAuthenticator,
    };
