import 'package:flutter/material.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/config/asset_loader.dart';
import 'package:precept_client/inject/modules.dart';
import 'package:precept_client/library/part_library.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/loader/assembler.dart';
import 'package:precept_script/loader/loaders.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/script/script.dart';

// TODO error handling, loader may fail

/// Loads the Precept models and initialises various parts of Precept
///
/// Considered having separate init calls for things like libraries, but the order of initialisation
/// is relevant in some cases - so it is just easier to put it all in one place.
///
/// Is constructed as a singleton
///
/// [init] must be called before the app is run
class Precept {
  late PScript _rootModel;
  late Map<String, dynamic> _jsonConfig;
  bool _isReady = false;
  final List<Function()> _readyListeners = List.empty(growable: true);
  final List<Function()> _scriptReloadListeners = List.empty(growable: true);
  final bool useDefaultDataProvider;
  late List<PreceptLoader> _loaders;
  late Map<Type, Widget Function(PPart, ModelConnector)>
      _particleLibraryEntries;

  Precept({this.useDefaultDataProvider = true});

  init({
    bool includePreceptDefaults = true,
    Map<String, Widget Function(PPage)> pageLibraryEntries = const {},
    Map<Type, Widget Function(PPart, ModelConnector)> particleLibraryEntries =
        const {},
    List<PreceptLoader> loaders = const [],
    List<void Function()> injectionBindings = const [],
  }) async {
    if (includePreceptDefaults || injectionBindings.isEmpty) {
      preceptDefaultInjectionBindings();
    }
    WidgetsFlutterBinding.ensureInitialized();
    _jsonConfig =
        await inject<JsonAssetLoader>().loadFile(filePath: 'precept.json');
    _loaders = loaders;
    _particleLibraryEntries = particleLibraryEntries;
    await _loadScripts();
    await _doAfterLoad();
  }

  _loadScripts() async {
    _rootModel = await ScriptAssembler().assemble(loaders: _loaders);
    _rootModel.init();
  }

  _doAfterLoad() async {
    await _loadSchemas();
    partLibrary.init(entries: _particleLibraryEntries);
    dataProviderLibrary.init(AppConfig(_jsonConfig));

    /// register the default data provider
    if (useDefaultDataProvider) {
      dataProviderLibrary.register(
          configType: PDataProvider,
          builder: (config) => DefaultDataProvider(config: config));
    }
    _isReady = true;
    notifyReadyListeners();
    notifyScriptReloadListeners();
  }

  reload() async {
    _isReady = false;
    notifyReadyListeners();
    await _loadScripts();
    await _doAfterLoad();
  }

  addScriptReloadListener(Function() listener) {
    _scriptReloadListeners.add(listener);
  }

  /// Walks the PScript to find any declared [PSchemaSource] instances, and calls them to be loaded,
  /// if they are not already loaded
  Future<bool> _loadSchemas() async {
    final visitor = DataProviderVisitor();
    _rootModel.walk([visitor]);
    final List<PDataProvider> requireLoading = List.empty(growable: true);

    /// select those which have no schema, for loading
    for (PDataProvider provider in visitor.dataProviders) {
      requireLoading.add(provider);
    }

    if (requireLoading.length > 0) {
      for (PDataProvider provider in requireLoading) {
        RestPreceptLoader loader = RestPreceptLoader();
      }
    }
    return true;
  }

  /// Call is not actioned if Precept already in ready state
  addReadyListener(Function() listener) {
    if (!_isReady) {
      _readyListeners.add(listener);
    }
  }

  notifyReadyListeners() {
    for (Function() listener in _readyListeners) {
      listener();
    }
  }

  notifyScriptReloadListeners() {
    for (Function() listener in _scriptReloadListeners) {
      listener();
    }
  }

  bool get isReady => _isReady;

  Map<String, dynamic> getConfig(String segment) {
    return _jsonConfig[segment];
  }
}

final Precept _precept = Precept();

Precept get precept => _precept;

PScript script = _precept._rootModel;

/// When used with [script.walk] returns all [PDataProvider] instances
class DataProviderVisitor implements ScriptVisitor {
  List<PDataProvider> dataProviders = List.empty(growable: true);

  @override
  step(Object entry) {
    if (entry is PDataProvider) {
      dataProviders.add(entry);
    }
  }
}
