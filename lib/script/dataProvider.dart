import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/configLoader.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'dataProvider.g.dart';

/// Configuration for a [Backend]
///
/// - [instanceName] and [env] serve much the same purpose.  Either can be used as an additional key
/// to lookup from the [BackendLibrary], in order to support multiple instances of the same type.
/// If only a single instance of a type is used (generally the case), neither need to be specified.
/// If both are specified, [instanceName] takes precedence
///
/// [headers] is different for each backend implementation, and is therefore just a map.
/// Use this to pass things like connection string, client keys etc
/// This may be redundant if a backend specific sub-class captures properties differently.
/// This may be specified directly, or loaded using [loadConfig]
///
/// if [loadConfig] is used, [configFilePath] must be specified
/// Either [configFilePath] or [headers] must be specified
///
///
@JsonSerializable(nullable: true, explicitToJson: true)
class PRestDataProvider extends PDataProvider  {
  final String baseUrl;
  final String instanceName;
  final PScript parent;
  final bool checkHealthOnConnect;
  final Env env;
  final String configFilePath;
  ConfigState _configState = ConfigState.idle;
  final Set<Function(ConfigState)> listeners = Set();

  PRestDataProvider({
    @required String instanceName,
    @required this.env,
    this.baseUrl,
    this.parent,
    this.checkHealthOnConnect = true,
    this.configFilePath,
    String id,
  })  : instanceName = instanceName ?? ((env == null) ? 'default' : env.toString()),
        super(id: id);

  factory PRestDataProvider.fromJson(Map<String, dynamic> json) => _$PRestDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PRestDataProviderToJson(this);

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

  Map<String,String> get headers=> {};

  doInit(PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(parent, index, useCaptionsAsIds: useCaptionsAsIds);
  }

  /// This method must always be called before attempting to use this configuration, even if the
  /// [headers] is manually specified.  This ensures that [_configState] is correct.
  ///
  /// The listener is added to listeners, as there may be other listeners as well
  ///
  /// If [headers] has been manually specified, config loaded from file is added to it, overwriting
  /// any entries with the same keys.
  ///
  /// [listeners] is a Set, so this may be called multiple times with the same [listener], and the
  /// listener will only be invoke once for each invocation of [_notifyListeners]
  ///
  /// Repeated calls will be ignored - once it is loaded it will not attempt to reload unless [forceReload] is true
  Future<ConfigState> loadConfig(
      {@required ConfigLoader configLoader,@required Function(ConfigState) listener, bool forceReload = false}) async {
    if (configState==ConfigState.loaded && !forceReload){
      return _configState;
    }
    assert(listener != null);
    assert(configLoader!=null);
    listeners.add(listener);
    _configState = ConfigState.loading;
    _notifyListeners();
    try {
      final data = await configLoader.loadFile(filePath: null);
      headers.addAll(data);
      _configState = ConfigState.loaded;
      _notifyListeners();
      return configState;
    } catch (e) {
      logType(this.runtimeType).e('Failed to load configuration from $configFilePath', e);
      _configState = ConfigState.failed;
      _notifyListeners();
      return configState;
    }
  }

  void _notifyListeners() {
    for (var listener in listeners) {
      listener(configState);
    }
  }

  ConfigState get configState => _configState;

  bool get isLoaded=> _configState==ConfigState.loaded;

  String get documentBaseUrl => baseUrl;

  String  documentUrl(DocumentId documentId){
    return '$documentBaseUrl/${documentId.path}/${documentId.itemId}';
  }
}

enum Env { dev, test, qa, prod }
enum ConfigState { idle, loading, loaded, failed }

abstract class PDataProvider extends PreceptItem{
  String get instanceName;
  PDataProvider({String id}) : super(id: id);

  bool get isLoaded;
  Future<ConfigState> loadConfig(
      {@required ConfigLoader configLoader,@required Function(ConfigState) listener, bool forceReload = false});
}