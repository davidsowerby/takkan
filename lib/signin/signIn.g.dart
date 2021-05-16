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

PSignIn _$PSignInFromJson(Map<String, dynamic> json) {
  return PSignIn(
    email: PEmailSignIn.fromJson(json['email'] as Map<String, dynamic>),
    successRoute: json['successRoute'] as String,
    failureRoute: json['failureRoute'] as String,
  );
}

Map<String, dynamic> _$PSignInToJson(PSignIn instance) => <String, dynamic>{
      'email': instance.email.toJson(),
      'successRoute': instance.successRoute,
      'failureRoute': instance.failureRoute,
    };

PEmailSignIn _$PEmailSignInFromJson(Map<String, dynamic> json) {
  return PEmailSignIn(
    emailLabel: json['emailLabel'] as String,
    usernameLabel: json['usernameLabel'] as String,
    passwordLabel: json['passwordLabel'] as String,
    submitLabel: json['submitLabel'] as String,
  );
}

Map<String, dynamic> _$PEmailSignInToJson(PEmailSignIn instance) =>
    <String, dynamic>{
      'emailLabel': instance.emailLabel,
      'usernameLabel': instance.usernameLabel,
      'passwordLabel': instance.passwordLabel,
      'submitLabel': instance.submitLabel,
    };
