import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/delegate.dart';
import 'package:takkan_script/data/provider/rest_delegate.dart';
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
  final String graphqlEndpoint;

  const GraphQL({
    this.graphqlEndpoint = '/graphql',
    super. checkHealthOnConnect = false,
  }) ;

  factory GraphQL.fromJson(Map<String, dynamic> json) =>
      _$GraphQLFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLToJson(this);
}
