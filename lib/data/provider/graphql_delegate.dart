import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/rest_delegate.dart';

part 'graphql_delegate.g.dart';

/// Config for a GraphQLDataProviderDelegate used in [PDataProvider].
///
/// See also [PRest]
///
/// [graphqlEndpoint] is appended to the server url
/// [sessionTokenKey] is the name of the key with which to retrieve a session token
/// When [checkHealthOnConnect] is true, the first time a connection is made, an API
/// health check is made (where supported by the DataProvider implementation)
///
/// [headerKeys] usually only need to be specified in [PDataProvider], but can
/// also be specified here if one delegate requires different keys to the other.
/// Delegate and Provider header keys are merged before use
@JsonSerializable(explicitToJson: true)
class PGraphQL extends PDataProviderDelegate {
  final String graphqlEndpoint;

  const PGraphQL({
    this.graphqlEndpoint = '/graphql',
    bool checkHealthOnConnect = false,
    List<String> headerKeys = const [],
  }) : super(
          checkHealthOnConnect: checkHealthOnConnect,
        );

  factory PGraphQL.fromJson(Map<String, dynamic> json) =>
      _$PGraphQLFromJson(json);

  Map<String, dynamic> toJson() => _$PGraphQLToJson(this);
}
