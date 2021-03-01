import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/configLoader.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'dataProvider.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PRestDataProvider extends PDataProvider {
  final String baseUrl;
  final bool checkHealthOnConnect;

  PRestDataProvider({
    @required PSchema schema,
    @required String instanceName,
    String configFilePath,
    this.baseUrl,
    this.checkHealthOnConnect = true,
    String id,
    Env env,
  }) : super(
          id: id,
          configFilePath: configFilePath,
          instanceName: instanceName,
          env: env,
          schema: schema,
        );

  factory PRestDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PRestDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PRestDataProviderToJson(this);

  String get documentBaseUrl => baseUrl;

  String documentUrl(DocumentId documentId) {
    return '$documentBaseUrl/${documentId.path}/${documentId.itemId}';
  }
}

enum Env { dev, test, qa, prod }

/// Configuration for a [DataProvider]
///
/// - [instanceName] and [env] serve much the same purpose.  Either can be used as an additional key
/// to lookup from the [BackendLibrary], in order to support multiple instances of the same type.
/// If only a single instance of a type is used, neither need to be specified.
/// If both are specified, [instanceName] takes precedence
///
/// [headers] specify things like client keys, and is therefore different for each backend implementation.
/// Each implementation must must provide the appropriate override.
///
/// This may be specified directly, or loaded using [loadConfig]
///
/// If [configFilePath] is specified, [loadConfig] is invoked by [doInit], and should normally override
/// directly declared declare entries - however this may be done differently in different implementations.
///
///
class PDataProvider extends PreceptItem {
  final String instanceName;
  final PSchema schema;
  final Env env;
  final String configFilePath;
  @JsonKey(ignore: true)
  bool _isLoaded = false;
  @JsonKey(ignore: true)
  bool _isLoading = false;

  @JsonKey(ignore: true)
  Function() _listener;

  PDataProvider(
      {this.schema, String id, String instanceName, @required this.configFilePath, this.env})
      : instanceName = instanceName ?? ((env == null) ? 'default' : env.toString()),
        super(id: id);

  @JsonKey(ignore: true)
  bool get isLoaded => _isLoaded;

  set listener(Function() listener) {
    _listener = listener;
  }

  @override
  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (instanceName == null || instanceName == '') {
      messages.add(ValidationMessage(item: this, msg: 'instanceName cannot be null or empty'));
    }
    if (headers == null && configFilePath == null) {
      messages.add(
          ValidationMessage(item: this, msg: 'connectionData or configFilePath must be specified'));
    }
  }

  Map<String, String> get headers => {};

  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    loadConfig();
  }

  /// This method must always be called before attempting to use this configuration, even if the
  /// [headers] is manually specified.  By default this is invoked by [doInit] method.
  ///
  /// If [headers] has been manually specified, config loaded from file is added to it, overwriting
  /// any entries with the same keys.
  ///
  /// Repeated calls will be ignored - once it is loaded it will not attempt to reload unless [forceReload] is true
  Future<bool> loadConfig({bool forceReload = false}) async {
    if ((_isLoading || _isLoaded) && !forceReload) {
      return true;
    }
    _isLoaded = false;
    _isLoading = true;
    try {
      final configLoader = inject<ConfigLoader>();
      if (configFilePath != null) {
        final data = await configLoader.loadFile(filePath: configFilePath);
        headers.addAll(data);
      }
      _isLoaded = true;
      _isLoading = false;
      if (_listener != null) {
        _listener();
      }
      return true;
    } catch (e) {
      logType(this.runtimeType).e('Failed to load configuration from $configFilePath', e);
      _isLoading = false;
      return false;
    }
  }
}
