import 'package:flutter/material.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_client/app/loader.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/config/assetLoader.dart';
import 'package:precept_client/inject/modules.dart';
import 'package:precept_client/library/partLibrary.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/converter/conversionErrorMessages.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validationErrorMessages.dart';
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
  late List<PreceptLoader> _loaders;
  late Map<Type, Widget Function(PPart, ModelConnector)> _particleLibraryEntries;

  Precept();

  init({
    bool includePreceptDefaults = true,
    bool useRestDataProvider = true,
    Map<String, Widget Function(PPage)> pageLibraryEntries = const {},
    Map<Type, Widget Function(PPart, ModelConnector)> particleLibraryEntries = const {},
    List<PreceptLoader> loaders = const [],
    List<void Function()> injectionBindings = const [],
  }) async {
    if (includePreceptDefaults || injectionBindings.isEmpty) {
      preceptDefaultInjectionBindings();
    }
    WidgetsFlutterBinding.ensureInitialized();
    _jsonConfig = await inject<JsonAssetLoader>().loadFile(filePath: 'precept.json');
    _loaders = loaders;
    _particleLibraryEntries = particleLibraryEntries;
    await loadScripts(loaders: _loaders);
    await _doAfterLoad();
  }

  _doAfterLoad() async {
    await _loadSchemas();
    partLibrary.init(entries: _particleLibraryEntries);
    dataProviderLibrary.init(AppConfig(_jsonConfig));
    _isReady = true;
    notifyReadyListeners();
    notifyScriptReloadListeners();
  }

  reload() async {
    _isReady = false;
    notifyReadyListeners();
    await loadScripts(loaders: _loaders);
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

  /// Loads all requested [PScript], and merges them into a single [_rootModel]
  loadScripts({required List<PreceptLoader> loaders}) async {
    logType(this.runtimeType).d("Loading models");
    List<Future<PScript>> modelFutures = List.empty(growable: true);
    for (PreceptLoader loader in loaders) {
      modelFutures.add(loader.load());
    }
    final m = await Future.wait(modelFutures);
    logType(this.runtimeType).d("All models loaded");
    if (m.length > 1) {
      _mergeModels(m);
    } else {
      _rootModel = m[0];
    }
    _rootModel.init();
  }

  /// Merging is carried out in the order specified in [models], and follows these principles:
  /// - for single value properties (such as authenticator), a non-null value overwrites a previous value
  /// - for multi-value properties (lists and maps), values are added to previous values.  This means that
  /// later map values will overwrite earlier entries with the same keys.
  /// - [ConversionErrorMessages] and [ValidationErrorMessages] are merged as maps
  /// - name and id is always taken from the first entry in [models]
  ///
  /// This is a bit of a sledgehammer approach, see [open issue](https://gitlab.com/precept1/precept-client/-/issues/2).
  _mergeModels(List<PScript> models) {
    final PScript firstModel = models[0];
    String name = firstModel.name;
    String id = firstModel.id ?? name;
    Map<String, PPage> pages = Map();
    final ConversionErrorMessages conversionErrorMessages =
        ConversionErrorMessages(patterns: Map());
    final ValidationErrorMessages validationErrorMessages =
        ValidationErrorMessages(typePatterns: Map());
    IsStatic isStatic = IsStatic.inherited;
    PDataProvider? dataProvider;
    PQuery? query;
    ControlEdit controlEdit = ControlEdit.firstLevelPanels;
    for (PScript s in models) {
      pages.addAll(s.pages);
      conversionErrorMessages.patterns
          .addAll(s.conversionErrorMessages.patterns);
      validationErrorMessages.typePatterns
          .addAll(s.validationErrorMessages.typePatterns);
      isStatic = s.isStatic;
      if (s.dataProviderIsDeclared) dataProvider = s.dataProvider;
      if (s.queryIsDeclared) query = s.query;
      controlEdit = s.controlEdit;
      _rootModel = PScript(
        name: name,
        pages: pages,
        id: id,
        conversionErrorMessages: conversionErrorMessages,
        validationErrorMessages: validationErrorMessages,
        isStatic: isStatic,
        query: query,
        dataProvider: dataProvider,
        controlEdit: controlEdit,
      );
    }
  }
}

final Precept _precept = Precept();

Precept get precept => _precept;

PScript script = _precept._rootModel;

/// When used with [script.walk] returns all [PDataProvider] instances
class DataProviderVisitor implements ScriptVisitor {
  List<PDataProvider> dataProviders = List.empty(growable: true);

  @override
  step(PreceptItem entry) {
    if (entry is PDataProvider) {
      dataProviders.add(entry);
    }
  }
}
