import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/restDataProvider.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/signin/signIn.dart';

part 'graphqlDataProvider.g.dart';

/// A GraphQL implementation of [PDataProviderBase].  This is the preferred implementation, simply
/// because it allows the developer to specify any valid GraphQL script
///
/// The alternative, [PRestDataProvider], is more limited in its scope
///
/// Either [schema] or [schemaSource] can be set.
///
///[schema] can be set directly during development, [schemaSource] is required for production use.
///
///If [schema] is not set, it is loaded on demand from the source specified by [schemaSource]
///The presence of [schema] should therefore be tested before using it.
///
///[_appConfig] is set during app initialisation (see [Precept.init] in the client package), and
///represents the contents of **precept.json**
@JsonSerializable(explicitToJson: true)
class PGraphQLDataProvider extends PDataProviderBase {
  final String graphqlEndpoint;

  PGraphQLDataProvider({
    required PConfigSource configSource,
    PSchemaSource? schemaSource,
    bool checkHealthOnConnect = false,
    PSchema? schema,
    PSignInOptions signInOptions = const PSignInOptions(),
    PSignIn signIn = const PSignIn(),
    required String sessionTokenKey,
    required List<String> headerKeys,
    required this.graphqlEndpoint,
    required String documentEndpoint,
    String? id,
  }) : super(
          id: id,
          documentEndpoint: documentEndpoint,
          headerKeys: headerKeys,
          sessionTokenKey: sessionTokenKey,
          configSource: configSource,
          checkHealthOnConnect: checkHealthOnConnect,
          schemaSource: schemaSource,
          schema: schema,
          signInOptions: signInOptions,
          signIn: signIn,
        );
}
