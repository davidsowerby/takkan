import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/delegate.dart';
import 'package:takkan_script/data/provider/graphql_delegate.dart';

part 'rest_delegate.g.dart';

/// Config for a RestDataProviderDelegate used in [DataProvider].
///
/// See also [GraphQL]
///
/// [documentEndpoint] is appended to the server url to point to the base url for documents.
/// In Back4App, for example, this is '/classes'
/// When [checkHealthOnConnect] is true, the first time a connection is made, an API
/// health check is made (where supported by the DataProvider implementation)
///
@JsonSerializable(explicitToJson: true)
class Rest extends DataProviderDelegate {
  final String documentEndpoint;

  const Rest({
    this.documentEndpoint = '/classes',
    super. checkHealthOnConnect = false,
  }) ;

  factory Rest.fromJson(Map<String, dynamic> json) => _$RestFromJson(json);

  Map<String, dynamic> toJson() => _$RestToJson(this);
}
