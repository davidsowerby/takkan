import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/restDelegate.dart';

part 'graphqlDelegate.g.dart';

/// A GraphQL implementation of [PDataProvider].  This is the preferred implementation, simply
/// because it allows the developer to specify any valid GraphQL script
///
/// The alternative, [PRestDelegate], is more limited in its scope
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
class PGraphQLDelegate {
  final String graphqlEndpoint;
  final String sessionTokenKey;
  final bool checkHealthOnConnect;

  const PGraphQLDelegate({
    required this.sessionTokenKey,
    required this.graphqlEndpoint,
    required this.checkHealthOnConnect,
  });

  factory PGraphQLDelegate.fromJson(Map<String, dynamic> json) =>
      _$PGraphQLDelegateFromJson(json);

  Map<String, dynamic> toJson() => _$PGraphQLDelegateToJson(this);
}