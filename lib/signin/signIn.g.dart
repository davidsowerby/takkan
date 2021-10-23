// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signIn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSignInOptions _$PSignInOptionsFromJson(Map<String, dynamic> json) =>
    PSignInOptions(
      pageTitle: json['pageTitle'] as String? ?? 'SignIn / Register',
      google: json['google'] as bool? ?? false,
      facebook: json['facebook'] as bool? ?? false,
      gitLab: json['gitLab'] as bool? ?? false,
      amazon: json['amazon'] as bool? ?? false,
      gitHub: json['gitHub'] as bool? ?? false,
      email: json['email'] as bool? ?? true,
    );

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

PSignIn _$PSignInFromJson(Map<String, dynamic> json) => PSignIn(
      successRoute: json['successRoute'] as String? ?? '',
      failureRoute: json['failureRoute'] as String? ?? 'signInFail',
    );

Map<String, dynamic> _$PSignInToJson(PSignIn instance) => <String, dynamic>{
      'successRoute': instance.successRoute,
      'failureRoute': instance.failureRoute,
    };

PEmailSignIn _$PEmailSignInFromJson(Map<String, dynamic> json) => PEmailSignIn(
      signInFailureMessage: json['signInFailureMessage'] as String? ??
          'Username or password incorrect',
      caption: json['caption'] as String? ?? 'Sign in with Email',
      checkingCredentialsMessage:
          json['checkingCredentialsMessage'] as String? ??
              'Checking Credentials',
      emailCaption: json['emailCaption'] as String? ?? 'email',
      usernameCaption: json['usernameCaption'] as String? ?? 'username',
      passwordCaption: json['passwordCaption'] as String? ?? 'password',
      submitCaption: json['submitCaption'] as String? ?? 'Submit',
      successRoute: json['successRoute'] as String? ?? '',
      failureRoute: json['failureRoute'] as String? ?? 'signInFail',
      readTraitName: json['readTraitName'] as String? ?? 'EmailSignIn-default',
      pid: json['pid'] as String?,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PEmailSignInToJson(PEmailSignIn instance) =>
    <String, dynamic>{
      'pid': instance.pid,
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
      'signInFailureMessage': instance.signInFailureMessage,
    };
