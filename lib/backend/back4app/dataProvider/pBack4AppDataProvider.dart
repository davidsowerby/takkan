import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/graphqlDataProvider.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/signin/signIn.dart';

part 'pBack4AppDataProvider.g.dart';

/// When [debug] enabled, prints logs to console
@JsonSerializable(explicitToJson: true)
class PBack4AppDataProvider extends PGraphQLDataProvider {

  final bool debug;
  final String serverUrl;

  PBack4AppDataProvider({
    this.debug = true,
    this.serverUrl = 'https://parseapi.back4app.com/',
    required PConfigSource configSource,
    String? id,
    PSchema? schema,
    bool checkHealthOnConnect = false,
    PSignInOptions signInOptions = const PSignInOptions(),
  }) : super(
      sessionTokenKey: 'X-Parse-Session-Token',
      documentEndpoint: notSet,
      graphqlEndpoint: notSet,
      signInOptions: signInOptions,
      schema: schema,
      checkHealthOnConnect: checkHealthOnConnect,
      configSource: configSource,
      id: id,
      headerKeys: const[],
  );

  @override
  String get documentEndpoint => '$serverUrl/classes';

  @override
  String get graphqlEndpoint => '$serverUrl/graphql';

  factory PBack4AppDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PBack4AppDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PBack4AppDataProviderToJson(this);

  String get idPropertyName => 'objectId';

  @override
  List<String> get headerKeys => ['X-Parse-Application-Id', 'X-Parse-Client-Key'];
}
