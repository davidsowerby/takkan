import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/graphqlDelegate.dart';
import 'package:precept_script/data/provider/restDelegate.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/signin/signIn.dart';

part 'pBack4AppDataProvider.g.dart';

/// When [debug] enabled, prints logs to console
@JsonSerializable(explicitToJson: true)

/// The server url is defined in *precept.json* and used in conjunction with some
/// of the properties below. *precept.json* is loaded into AppConfig during application
/// initialisation.
///
/// [documentEndpoint] is the REST endpoint in relation to the server url
/// [graphqlEndpoint] is the GraphQL endpoint in relation to the server url class PBack4AppDataProvider
    extends PDataProvider {
  PBack4AppDataProvider({
    PSignInOptions signInOptions = const PSignInOptions(),
    PSignIn signIn = const PSignIn(),
    required PConfigSource configSource,
    PSchemaSource? schemaSource,
    bool checkHealthOnConnect = false,
    CloudInterface authenticatorDelegate = CloudInterface.graphQL,
    CloudInterface scriptDelegate = CloudInterface.graphQL,
    PSchema? schema,
  }) : super(
    schema: schema,
    signIn: signIn,
    signInOptions: signInOptions,
    configSource: configSource,
    graphQLDelegate: PGraphQL(sessionTokenKey: 'sessionToken'),
    restDelegate: PRest(sessionTokenKey: 'sessionToken'),
    authenticatorDelegate: authenticatorDelegate,
    headerKeys: const ['X-Parse-Application-Id', 'X-Parse-Client-Key'],
    sessionTokenKey: 'sessionToken',
  );

  String get idPropertyName => 'objectId';
  factory PBack4AppDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PBack4AppDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PBack4AppDataProviderToJson(this);


}
