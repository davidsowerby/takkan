import 'package:json_annotation/json_annotation.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/userConverter.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/constants.dart';
import 'package:precept_backend/backend/authenticator.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/dataProvider/restDataProvider.dart';
import 'package:precept_backend/backend/preceptUser.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataProvider.dart';

part 'pBack4AppDataProvider.g.dart';

/// When [debug] enabled, prints logs to console
@JsonSerializable(nullable: true, explicitToJson: true)
class PBack4AppDataProvider extends PRestDataProvider {
  static const appIdKey = 'applicationId';
  static const clientIdKey = 'clientId';
  static const baseUrlKey = 'serverUrl';

  final bool debug;
  final String appId;
  final String clientId;

  PBack4AppDataProvider({
    this.debug = true,
    this.appId,
    this.clientId,
    String baseUrl,
    String id,
    PSchema schema,
    bool checkHealthOnConnect,
  }) : super(
          schema: schema,
          baseUrl: baseUrl,
          checkHealthOnConnect: checkHealthOnConnect,
          id: id,
        );

  PBack4AppDataProvider.fromConfig({
    PSchema schema,
    Map<String, dynamic> jsonConfig,
    String id,
    this.debug = true,
  })  : clientId = jsonConfig[clientIdKey],
        appId = jsonConfig[appIdKey],
        super(
          schema: schema,
          id: id,
          baseUrl: jsonConfig[baseUrlKey],
        );

  factory PBack4AppDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PBack4AppDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PBack4AppDataProviderToJson(this);

  @override
  Map<String, String> get headers => {keyHeaderApplicationId: appId, keyHeaderClientKey: clientId};

  String get documentBaseUrl => '$baseUrl/classes';

  static register() {
    dataProviderLibrary.register(
        config: PBack4AppDataProvider, builder: (config) => RestDataProvider(config: config));
    getIt.registerSingleton<Authenticator>(Back4AppAuthenticator());
    getIt.registerSingleton<PreceptUserConverter>(Back4AppUserConverter());
  }
}
