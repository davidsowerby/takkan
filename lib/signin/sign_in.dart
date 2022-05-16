import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/help.dart';
import 'package:takkan_script/part/part.dart';

part 'sign_in.g.dart';

/// Determines which sign-in options are presented to a user
@JsonSerializable(explicitToJson: true)
class SignInOptions {
  final String pageTitle;
  final bool email;
  final bool google;
  final bool facebook;
  final bool gitLab;
  final bool amazon;
  final bool gitHub;

  const SignInOptions({
    this.pageTitle = 'SignIn / Register',
    this.google = false,
    this.facebook = false,
    this.gitLab = false,
    this.amazon = false,
    this.gitHub = false,
    this.email = true,
  });

  factory SignInOptions.fromJson(Map<String, dynamic> json) =>
      _$SignInOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$SignInOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SignIn {
  final String successRoute;
  final String failureRoute;

  const SignIn({
    this.successRoute = '',
    this.failureRoute = 'signInFail',
  });

  factory SignIn.fromJson(Map<String, dynamic> json) => _$SignInFromJson(json);

  Map<String, dynamic> toJson() => _$SignInToJson(this);
}

/// An empty String in [successRoute] (the default) will navigate to the user to the page they were
/// on before signing in.
/// [failureRoute] is for when authentication fails completely (after maximum retries).  A failed
/// attempt is handled by a change of [Authenticator.status], and managed within the sign in page
@JsonSerializable(explicitToJson: true)
class EmailSignIn extends Part {
  static const String defaultTrait = 'EmailSignIn-default';
  final String emailCaption;
  final String usernameCaption;
  final String passwordCaption;
  final String checkingCredentialsMessage;

  final String submitCaption;
  final String successRoute;
  final String failureRoute;
  final String signInFailureMessage;

  EmailSignIn({
    this.signInFailureMessage = 'Username or password incorrect',
    super. caption = 'Sign in with Email',
    this.checkingCredentialsMessage = 'Checking Credentials',
    this.emailCaption = 'email',
    this.usernameCaption = 'username',
    this.passwordCaption = 'password',
    this.submitCaption = 'Submit',
    this.successRoute = '',
    this.failureRoute = 'signInFail',
    super. readTraitName = 'EmailSignIn-default',
    super. id,
    Help? help,
  }) : super(
    help: help,
          readOnly: true,
          staticData: '',
          controlEdit: ControlEdit.noEdit,
        );

  factory EmailSignIn.fromJson(Map<String, dynamic> json) =>
      _$EmailSignInFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmailSignInToJson(this);
}
