import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:precept_client/app/loader.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/config/assetLoader.dart';
import 'package:precept_client/inject/modules.dart';
import 'package:precept_client/library/partLibrary.dart';
import 'package:precept_client/trait/traitLibrary.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/error.dart';
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
  PScript _rootModel;
  Map<String, dynamic> _jsonConfig;
  bool _isReady = false;
  final List<Function()> _readyListeners = List.empty(growable: true);
  List<PreceptLoader> _loaders;
  Map<Type, Widget Function(PPart, ModelConnector)> _particleLibraryEntries;

  Precept();

  init({
    List<Function()> injectionBindings,
    Map<String, Trait> Function(ThemeData theme) traits,
    bool includePreceptDefaults = true,
    Map<String, Widget Function(PPage)> pageLibraryEntries,
    Map<Type, Widget Function(PPart, ModelConnector)> particleLibraryEntries,
    Widget Function(PError) errorPage,
    List<PreceptLoader> loaders = const [],
  }) async {
    if (includePreceptDefaults || injectionBindings == null || injectionBindings.isEmpty) {
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
    _isReady = true;
    notifyReadyListeners();
  }

  reload() async {
    _isReady = false;
    notifyReadyListeners();
    await loadScripts(loaders: _loaders);
    await _doAfterLoad();
  }

  /// Walks the PScript to find any declared [PSchemaSource] instances, and calls them to be loaded,
  /// if they are not already loaded
  Future<bool> _loadSchemas() async {
    final visitor = DataProviderVisitor();
    _rootModel.walk([visitor]);
    final List<PDataProvider> requireLoading = List.empty(growable: true);

    /// select those which have no schema, for loading
    /// Also sets gives the provider a copy of the JSON config loaded from **precept.json**
    for (PDataProvider provider in visitor.dataProviders) {
      if (provider.schema == null) {
        requireLoading.add(provider);
      }
      provider.appConfig = _jsonConfig;
    }

    if (requireLoading.length > 0) {
      for (PDataProvider provider in requireLoading) {
        RestPreceptLoader loader = RestPreceptLoader();
      }
    }
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

  bool get isReady => _isReady;

  Map<String, dynamic> getConfig(String segment) {
    return _jsonConfig[segment];
  }

  /// Loads all requested [PScript], and merges them into a single [_rootModel]
  loadScripts({@required List<PreceptLoader> loaders}) async {
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
    String name = models[0].name;
    String id = models[0].id;
    Map<String, PPage> pages = Map();
    final ConversionErrorMessages conversionErrorMessages = ConversionErrorMessages(patterns: Map());
    final ValidationErrorMessages validationErrorMessages = ValidationErrorMessages(typePatterns: Map());
    IsStatic isStatic = IsStatic.inherited;
    PDataProvider dataProvider;
    PQuery query;
    ControlEdit controlEdit = ControlEdit.firstLevelPanels;
    for (PScript s in models) {
      if (s.pages != null) pages.addAll(s.pages);
      if (s.conversionErrorMessages != null)
        conversionErrorMessages.patterns.addAll(s.conversionErrorMessages.patterns);
      if (s.validationErrorMessages != null)
        validationErrorMessages.typePatterns.addAll(s.validationErrorMessages.typePatterns);
      if (s.isStatic != null) isStatic = s.isStatic;
      if (s.dataProviderIsDeclared) dataProvider = s.dataProvider;
      if (s.queryIsDeclared) query = s.query;
      if (s.controlEdit != null) controlEdit = s.controlEdit;
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
