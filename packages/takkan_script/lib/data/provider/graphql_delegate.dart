import 'package:json_annotation/json_annotation.dart';
import 'data_provider.dart';
import 'delegate.dart';
import 'rest_delegate.dart';
part 'graphql_delegate.g.dart';

/// Config for a GraphQLDataProviderDelegate used in [DataProvider].
///
/// See also [Rest]
///
/// [graphqlEndpoint] is appended to the server url
/// When [checkHealthOnConnect] is true, the first time a connection is made, an API
/// health check is made (where supported by the DataProvider implementation)
///
@JsonSerializable(explicitToJson: true)
class GraphQL extends DataProviderDelegate {
  const GraphQL({
    this.graphqlEndpoint = '/graphql',
    super.checkHealthOnConnect = false,
  });

  factory GraphQL.fromJson(Map<String, dynamic> json) =>
      _$GraphQLFromJson(json);
  final String graphqlEndpoint;

  Map<String, dynamic> toJson() => _$GraphQLToJson(this);
}
