import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/signIn.dart';

part 'authenticator.g.dart';

/// For this class, the [schema] is likely only to be needed for the 'user' class.
@JsonSerializable(nullable: true, explicitToJson: true)
class PAuthenticator extends PDataProvider {
  final PSignInOptions signInOptions;

  PAuthenticator({
    this.signInOptions = const PSignInOptions(),
    String id,
    String instanceName,
    Env env,
    String configFilePath,
    PSchema schema,
  }) : super(
          id: id,
          configFilePath: configFilePath,
          instanceName: instanceName,
          env: env,
          schema: schema,
        );

  factory PAuthenticator.fromJson(Map<String, dynamic> json) => _$PAuthenticatorFromJson(json);

  Map<String, dynamic> toJson() => _$PAuthenticatorToJson(this);
}
