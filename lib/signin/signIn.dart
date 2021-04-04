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
    this.pageTitle='SignIn / Register',
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
