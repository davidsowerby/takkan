import 'package:json_annotation/json_annotation.dart';
import 'package:precept_back4app_backend/backend/back4app/constants.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/dataProvider/restDataProvider.dart';
import 'package:precept_script/script/dataProvider.dart';

part 'pBack4AppDataProvider.g.dart';

/// When [debug] enabled, prints logs to console
@JsonSerializable(nullable: true, explicitToJson: true)
class PBack4AppDataProvider extends PRestDataProvider {
  final bool debug;
  final String appId;
  final String clientKey;

  PBack4AppDataProvider({
    this.debug = true,
    this.appId,
    this.clientKey,
    String baseUrl,
    String instanceName,
    Env env,
    bool checkHealthOnConnect,
  }) : super(
          instanceName: instanceName,
          env: env,
          checkHealthOnConnect: checkHealthOnConnect,
          baseUrl: baseUrl,
        );

  factory PBack4AppDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PBack4AppDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PBack4AppDataProviderToJson(this);

  @override
  Map<String, String> get headers => {keyHeaderApplicationId: appId, keyHeaderClientKey: clientKey};

  String get documentBaseUrl => '$baseUrl/classes';

  static register() {
    dataProviderLibrary.register(
        config: PBack4AppDataProvider, builder: (config) => RestDataProvider(config: config));
  }
}
