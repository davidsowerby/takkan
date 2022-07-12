// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../part/part.dart';
import '../script/help.dart';
import '../script/script_element.dart';
import '../script/takkan_element.dart';

part 'sign_in.g.dart';

/// Determines which sign-in options are presented to a user
@JsonSerializable(explicitToJson: true)
class SignInOptions {
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
  final String pageTitle;
  final bool email;
  final bool google;
  final bool facebook;
  final bool gitLab;
  final bool amazon;
  final bool gitHub;

  Map<String, dynamic> toJson() => _$SignInOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SignIn {
  const SignIn({
    this.successRoute = '',
    this.failureRoute = 'signInFail',
  });

  factory SignIn.fromJson(Map<String, dynamic> json) => _$SignInFromJson(json);
  final String successRoute;
  final String failureRoute;

  Map<String, dynamic> toJson() => _$SignInToJson(this);
}

/// An empty String in [successRoute] (the default) will navigate to the user to the page they were
/// on before signing in.
/// [failureRoute] is for when authentication fails completely (after maximum retries).  A failed
/// attempt is handled by a change of [Authenticator.status], and managed within the sign in page
@JsonSerializable(explicitToJson: true)
class EmailSignIn extends Part {
  EmailSignIn({
    this.signInFailureMessage = 'Username or password incorrect',
    super.caption = 'Sign in with Email',
    this.checkingCredentialsMessage = 'Checking Credentials',
    this.emailCaption = 'email',
    this.usernameCaption = 'username',
    this.passwordCaption = 'password',
    this.submitCaption = 'Submit',
    this.successRoute = '',
    this.failureRoute = 'signInFail',
    super.traitName = 'EmailSignIn-default',
    super.id,
    super.help,
  }) : super(
          readOnly: true,
          staticData: '',
          controlEdit: ControlEdit.noEdit,
        );

  factory EmailSignIn.fromJson(Map<String, dynamic> json) =>
      _$EmailSignInFromJson(json);
  static const String defaultTrait = 'EmailSignIn-default';
  final String emailCaption;
  final String usernameCaption;
  final String passwordCaption;
  final String checkingCredentialsMessage;

  final String submitCaption;
  final String successRoute;
  final String failureRoute;
  final String signInFailureMessage;

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [
        ...super.props,
        signInFailureMessage,
        checkingCredentialsMessage,
        emailCaption,
        usernameCaption,
        passwordCaption,
        submitCaption,
        successRoute,
        failureRoute,
      ];

  @override
  Map<String, dynamic> toJson() => _$EmailSignInToJson(this);
}
