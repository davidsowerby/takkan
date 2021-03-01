// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signIn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSignInOptions _$PSignInOptionsFromJson(Map<String, dynamic> json) {
  return PSignInOptions(
    pageTitle: json['pageTitle'] as String,
    google: json['google'] as bool,
    facebook: json['facebook'] as bool,
    gitLab: json['gitLab'] as bool,
    amazon: json['amazon'] as bool,
    gitHub: json['gitHub'] as bool,
    email: json['email'] as bool,
  );
}

Map<String, dynamic> _$PSignInOptionsToJson(PSignInOptions instance) =>
    <String, dynamic>{
      'pageTitle': instance.pageTitle,
      'email': instance.email,
      'google': instance.google,
      'facebook': instance.facebook,
      'gitLab': instance.gitLab,
      'amazon': instance.amazon,
      'gitHub': instance.gitHub,
    };
