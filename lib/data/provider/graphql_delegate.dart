import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/rest_delegate.dart';

part 'graphql_delegate.g.dart';

/// Config for a GraphQLDataProviderDelegate used in [DataProvider].
///
/// See also [Rest]
///
/// [graphqlEndpoint] is appended to the server url
/// [sessionTokenKey] is the name of the key with which to retrieve a session token
/// When [checkHealthOnConnect] is true, the first time a connection is made, an API
/// health check is made (where supported by the DataProvider implementation)
///
/// [headerKeys] usually only need to be specified in [DataProvider], but can
/// also be specified here if one delegate requires different keys to the other.
/// Delegate and Provider header keys are merged before use
@JsonSerializable(explicitToJson: true)
class GraphQL extends DataProviderDelegate {
  final String graphqlEndpoint;

  const GraphQL({
    this.graphqlEndpoint = '/graphql',
    bool checkHealthOnConnect = false,
    List<String> headerKeys = const [],
  }) : super(
          checkHealthOnConnect: checkHealthOnConnect,
        );

  factory GraphQL.fromJson(Map<String, dynamic> json) =>
      _$GraphQLFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLToJson(this);
}
