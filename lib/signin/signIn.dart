import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/part/part.dart';

part 'signIn.g.dart';

/// Determines which sign-in options are presented to a user
@JsonSerializable(explicitToJson: true)
class PSignInOptions {
  final String pageTitle;
  final bool email;
  final bool google;
  final bool facebook;
  final bool gitLab;
  final bool amazon;
  final bool gitHub;

  const PSignInOptions({
    this.pageTitle = 'SignIn / Register',
    this.google = false,
    this.facebook = false,
    this.gitLab = false,
    this.amazon = false,
    this.gitHub = false,
    this.email = true,
  });

  factory PSignInOptions.fromJson(Map<String, dynamic> json) => _$PSignInOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PSignInOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PSignIn {
  final String successRoute;
  final String failureRoute;

  const PSignIn({
    this.successRoute = '',
    this.failureRoute = 'signInFail',
  });

  factory PSignIn.fromJson(Map<String, dynamic> json) => _$PSignInFromJson(json);

  Map<String, dynamic> toJson() => _$PSignInToJson(this);
}

/// An empty String in [successRoute] (the default) will navigate to the user to the page they were
/// on before signing in.
/// [failureRoute] is for when authentication fails completely (after maximum retries).  A failed
/// attempt is handled by a change of [Authenticator.status], and managed within the sign in page
@JsonSerializable(explicitToJson: true)
class PEmailSignIn extends PPart {
  static const String defaultTrait = 'EmailSignIn-default';
  final String emailCaption;
  final String usernameCaption;
  final String passwordCaption;
  final String checkingCredentialsMessage;

  final String submitCaption;
  final String successRoute;
  final String failureRoute;
  final String signInFailureMessage;

  PEmailSignIn({
    this.signInFailureMessage='Username or password incorrect',
    String caption = 'Sign in with Email',
    this.checkingCredentialsMessage='Checking Credentials',
    this.emailCaption = 'email',
    this.usernameCaption = 'username',
    this.passwordCaption = 'password',
    this.submitCaption = 'Submit',
    this.successRoute = '',
    this.failureRoute = 'signInFail',
    String readTraitName = defaultTrait,
    String? id,
    PHelp? help,
  }) : super(
          help: help,
          readOnly: true,
          staticData: '',
          readTraitName: readTraitName,
          isStatic: IsStatic.yes,
          controlEdit: ControlEdit.noEdit,
          caption: caption,
          id: id,
        );

  factory PEmailSignIn.fromJson(Map<String, dynamic> json) => _$PEmailSignInFromJson(json);

  Map<String, dynamic> toJson() => _$PEmailSignInToJson(this);
}
