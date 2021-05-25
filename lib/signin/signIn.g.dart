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
    successRoute: json['successRoute'] as String,
    failureRoute: json['failureRoute'] as String,
  );
}

Map<String, dynamic> _$PSignInToJson(PSignIn instance) => <String, dynamic>{
      'successRoute': instance.successRoute,
      'failureRoute': instance.failureRoute,
    };

PEmailSignIn _$PEmailSignInFromJson(Map<String, dynamic> json) {
  return PEmailSignIn(
    caption: json['caption'] as String,
    checkingCredentialsMessage: json['checkingCredentialsMessage'] as String,
    emailCaption: json['emailCaption'] as String,
    usernameCaption: json['usernameCaption'] as String,
    passwordCaption: json['passwordCaption'] as String,
    submitCaption: json['submitCaption'] as String,
    successRoute: json['successRoute'] as String,
    failureRoute: json['failureRoute'] as String,
    readTraitName: json['readTraitName'] as String,
    id: json['id'] as String?,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PEmailSignInToJson(PEmailSignIn instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'caption': instance.caption,
      'help': instance.help?.toJson(),
      'readTraitName': instance.readTraitName,
      'emailCaption': instance.emailCaption,
      'usernameCaption': instance.usernameCaption,
      'passwordCaption': instance.passwordCaption,
      'checkingCredentialsMessage': instance.checkingCredentialsMessage,
      'submitCaption': instance.submitCaption,
      'successRoute': instance.successRoute,
      'failureRoute': instance.failureRoute,
    };
