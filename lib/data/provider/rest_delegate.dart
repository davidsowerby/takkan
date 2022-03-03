import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/graphql_delegate.dart';

part 'rest_delegate.g.dart';

/// Config for a RestDataProviderDelegate used in [PDataProvider].
///
/// See also [PGraphQL]
///
/// [documentEndpoint] is appended to the server url to point to the base url for documents.
/// In Back4App, for example, this is '/classes'
/// [sessionTokenKey] is the name of the key with which to retrieve a session token
/// When [checkHealthOnConnect] is true, the first time a connection is made, an API
/// health check is made (where supported by the DataProvider implementation)
///
/// [headerKeys] usually only need to be specified in [PDataProvider], but can
/// also be specified here if one delegate requires different keys to the other.
/// Delegate and Provider header keys are merged before use
@JsonSerializable(explicitToJson: true)
class PRest extends PDataProviderDelegate {
  final String documentEndpoint;

  PRest({
    this.documentEndpoint = '/classes',
    bool checkHealthOnConnect = false,
    List<String> headerKeys = const [],
  }) : super(
          checkHealthOnConnect: checkHealthOnConnect,
        );

  factory PRest.fromJson(Map<String, dynamic> json) => _$PRestFromJson(json);

  Map<String, dynamic> toJson() => _$PRestToJson(this);
}
