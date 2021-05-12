import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/schema/schema.dart';

part 'pBack4AppDataProvider.g.dart';

/// When [debug] enabled, prints logs to console
@JsonSerializable(nullable: true, explicitToJson: true)
class PBack4AppDataProvider extends PDataProvider {
  static const String applicationIdKey = "X-Parse-Application-Id";
  static const String clientIdKey = "X-Parse-Client-Key";
  static const String serverUrlKey = "serverUrl";
  static const String endpointKey = "graphqlEndpoint";

  final bool debug;

  PBack4AppDataProvider({
    this.debug = true,
    PConfigSource configSource,
    String id,
    PSchema schema,
    bool checkHealthOnConnect,
  }) : super(
          schema: schema,
          checkHealthOnConnect: checkHealthOnConnect,
          configSource: configSource,
          id: id,
        );

  factory PBack4AppDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PBack4AppDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PBack4AppDataProviderToJson(this);

  String get documentBaseUrl => '$serverUrl/classes';

  String get idPropertyName => 'objectId';

  String get applicationId => instanceConfig[applicationIdKey];

  String get clientKey => instanceConfig[clientIdKey];
}
