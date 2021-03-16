import 'package:json_annotation/json_annotation.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/constants.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataProvider.dart';

part 'pBack4AppDataProvider.g.dart';

/// When [debug] enabled, prints logs to console
@JsonSerializable(nullable: true, explicitToJson: true)
class PBack4AppDataProvider extends PRestDataProvider {
  static const appIdKey = 'applicationId';
  static const clientIdKey = 'clientId';
  static const serverUrlKey = 'serverUrl';

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

  String get appId => appConfig[configSource.segment][configSource.instance][appIdKey];

  String get clientId => appConfig[configSource.segment][configSource.instance][clientIdKey];

  String get serverUrl => appConfig[configSource.segment][configSource.instance][serverUrlKey];

  @override
  Map<String, String> get headers => {keyHeaderApplicationId: appId, keyHeaderClientKey: clientId};
}
