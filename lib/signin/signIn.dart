import 'package:json_annotation/json_annotation.dart';

part 'signIn.g.dart';

/// Determines which sign-in options are presented to a user
@JsonSerializable(nullable: true, explicitToJson: true)
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

@JsonSerializable(nullable: true, explicitToJson: true)
class PSignIn {
  final PEmailSignIn email;
  final String successRoute;
  final String failureRoute;

  const PSignIn({
    this.email = const PEmailSignIn(),
    this.successRoute = '',
    this.failureRoute = 'signInFail',
  });

  factory PSignIn.fromJson(Map<String, dynamic> json) => _$PSignInFromJson(json);

  Map<String, dynamic> toJson() => _$PSignInToJson(this);
}

/// An empty String in [successRoute] (the default) will navigate to the user to the page they were
/// on before signing in.
@JsonSerializable(nullable: true, explicitToJson: true)
class PEmailSignIn {
  final String emailLabel;
  final String usernameLabel;
  final String passwordLabel;

  final String submitLabel;

  const PEmailSignIn({
    this.emailLabel = 'email',
    this.usernameLabel = 'username',
    this.passwordLabel = 'password',
    this.submitLabel = 'Submit',
  });

  factory PEmailSignIn.fromJson(Map<String, dynamic> json) => _$PEmailSignInFromJson(json);

  Map<String, dynamic> toJson() => _$PEmailSignInToJson(this);
}
