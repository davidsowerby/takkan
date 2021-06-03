import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/signin/signIn.dart';

part 'restDataProvider.g.dart';

/// Sensitive keys - such as API Keys - are held in **precept.json** in the project root directory.
/// [headerKeys], in conjeunction with [configSource], are used to look these keys from **precept.json**.
///
/// Key names may be different for each backend implementation.
///
/// Even if there is no requirement for an API key (usually true only for open public APIs),
/// [configSource] must still be specified
///
/// [serverUrl]
@JsonSerializable(explicitToJson: true)
class PRestDataProvider extends PDataProviderBase {
  final bool checkHealthOnConnect;
  final String? _serverUrl;

  PRestDataProvider({
    String? serverUrl,
    PSignInOptions signInOptions = const PSignInOptions(),
    PSchemaSource? schemaSource,
    PSchema? schema,
    this.checkHealthOnConnect = false,
    String? id,
    required PConfigSource configSource,
    PSignIn signIn = const PSignIn(),
    required String sessionTokenKey,
    required List<String> headerKeys,
  })   : _serverUrl = serverUrl,
        super(
          documentEndpoint: notSet,
          headerKeys: headerKeys,
          checkHealthOnConnect: checkHealthOnConnect,
          sessionTokenKey: sessionTokenKey,
          id: id,
          signInOptions: signInOptions,
          schema: schema,
          schemaSource: schemaSource,
          configSource: configSource,
          signIn: signIn,
        );

  factory PRestDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PRestDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PRestDataProviderToJson(this);
}
