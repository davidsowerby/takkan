import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/signin/signIn.dart';
import 'package:precept_script/validation/message.dart';

part 'dataProvider.g.dart';

/// [headers] specify things like client keys, and is therefore different for each backend implementation.
/// Each implementation must provide the appropriate override.
@JsonSerializable( explicitToJson: true)
class PRestDataProvider extends PDataProvider {
  final bool checkHealthOnConnect;

  PRestDataProvider({
    PSignInOptions signInOptions=const PSignInOptions(),
    PSchemaSource? schemaSource,
    PSchema? schema,
    this.checkHealthOnConnect = true,
    String? id,
    PConfigSource? configSource,
  }) : super(
          id: id,
          signInOptions: signInOptions,
          schema: schema,
          schemaSource: schemaSource,
          configSource: configSource,
        );

  factory PRestDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PRestDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PRestDataProviderToJson(this);

  String get endPointBase => serverUrl;

  String documentUrl(DocumentId documentId) {
    return '$endPointBase/${documentId.path}/${documentId.itemId}';
  }
}

/// Either [schema] or [schemaSource] can be set.
///
/// [schema] can be set directly during development, [schemaSource] is required for production use.
///
/// If [schema] is not set, it is loaded on demand from the configuration specified by [schemaSource]
/// The presence of [schema] should therefore be tested before using it.
///
/// [_appConfig] is set during app initialisation (see [Precept.init]), and represents the contents of
/// **precept.json**

@JsonSerializable( explicitToJson: true)
class PDataProvider extends PreceptItem {
  final PSignInOptions signInOptions;
  final PSignIn signIn;
  final PConfigSource? configSource;
  @JsonKey(ignore: true)
  Map<String, dynamic>? _appConfig;
  @JsonKey(ignore: true)
  PSchema? _schema;
  final PSchemaSource? schemaSource;
  final bool checkHealthOnConnect;

  @JsonKey(ignore: true)
  PSchema? get schema => _schema;

  set schema(value) => _schema = value;

  set appConfig(value) => _appConfig = value;

  @JsonKey(ignore: true)
  Map<String, dynamic>? get appConfig => _appConfig;

  PDataProvider({
    required this.configSource,
    this.checkHealthOnConnect=false,
    this.signInOptions = const PSignInOptions(),
    PSchema? schema,
    this.schemaSource,
    this.signIn=const PSignIn(),
    String? id,
  })  : _schema = schema,
        super(id: id);

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (schema == null && schemaSource == null) {
      messages.add(ValidationMessage(
          item: this, msg: "Either 'schema' or 'schemaSource' must be specified"));
    }
  }

  /// Creates headers from [appConfig] using [configSource] to look up the appropriate part of the data.
  /// [appConfig] has been loaded from **precept.json**.
  /// By default, all keys containing a '-' are assumed to be header keys
  Map<String, String> get headers {

    final h = Map<String, String>();
    for (MapEntry<String, dynamic> entry in instanceConfig.entries) {
      if (entry.key.contains('-')) {
        h[entry.key] = entry.value.toString();
      }
    }
    return h;
  }

  String get serverUrl => instanceConfig['serverUrl'];
  Map<String,dynamic> get instanceConfig=> _instanceConfig();

  String get graphqlEndpoint {
    final value=instanceConfig['graphqlEndpoint'];
    if (value==null){
      final msg='graphqlEndpoint must be specified in precept.json';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return value;
  }

  String get documentEndpoint {
    final value=instanceConfig['documentEndpoint'];
    if (value==null){
      final msg='documentEndpoint must be specified in precept.json';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return value;
  }

  _instanceConfig(){
    return appConfig?[configSource?.segment][configSource?.instance];
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (schemaSource != null) schemaSource?.walk(visitors);
  }

  /// This can be overridden, because Back4App for example, uses the objectId field value
  String get idPropertyName => 'id';
}

/// [segment] and [instance] together define which part **precept.json** is used to
/// configure a [DataProvider] connection
@JsonSerializable( explicitToJson: true)
class PConfigSource {
  final String segment;
  final String instance;

  const PConfigSource({required this.segment, required this.instance});

  factory PConfigSource.fromJson(Map<String, dynamic> json) => _$PConfigSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PConfigSourceToJson(this);
}

@JsonSerializable( explicitToJson: true)
class PNoDataProvider extends PDataProvider {
  PNoDataProvider()
      : super(
          configSource: PConfigSource(segment: 'none', instance: 'none'),
          schemaSource: PSchemaSource(segment: 'none', instance: 'none'),
        );

  factory PNoDataProvider.fromJson(Map<String, dynamic> json) => _$PNoDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PNoDataProviderToJson(this);
}


