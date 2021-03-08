import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:precept_client/app/loader.dart';
import 'package:precept_client/backend/backend.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/config/assetLoader.dart';
import 'package:precept_client/inject/modules.dart';
import 'package:precept_client/library/particleLibrary.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/converter/conversionErrorMessages.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validationErrorMessages.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/error.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/writingStyle.dart';

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
  Map<String,dynamic> _jsonConfig;
  bool _isReady=false;
  final List<Function()> _readyListeners=List.empty(growable: true);

  Precept();

  init({
    List<Function()> injectionBindings,
    Env env = Env.dev,
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
    _jsonConfig=await inject<JsonAssetLoader>().loadFile(filePath: 'precept.json');
    await loadModels(loaders: loaders);
    particleLibrary.init(entries: particleLibraryEntries);
    backend.init(_rootModel,_jsonConfig);
    _rootModel.defaultDataProvider=backend.dataProvider;
    _isReady=true;
    notifyReadyListeners();
  }

  /// Call is not actioned if Precept already in ready state
  addReadyListener(Function() listener){
    if (!_isReady) {
      _readyListeners.add(listener);
    }
  }

  notifyReadyListeners(){
    for (Function() listener in _readyListeners){
      listener();
    }
  }
  
  bool get isReady => _isReady;

  Map<String,dynamic> getConfig(String segment){
    return _jsonConfig[segment];
  }

  loadModels({@required List<PreceptLoader> loaders}) async {
    logType(this.runtimeType).d("Loading models");
    List<Future<PScript>> modelFutures = List();
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
    PBackend backend;
    Map<String, PRoute> routes = Map();
    final ConversionErrorMessages conversionErrorMessages = ConversionErrorMessages(Map());
    final ValidationErrorMessages validationErrorMessages = ValidationErrorMessages(Map());
    PSchema schema = PSchema(documents: Map(), name: 'root');
    IsStatic isStatic = IsStatic.inherited;
    PDataProvider dataProvider;
    PQuery query;
    PPanelStyle panelStyle;
    WritingStyle writingStyle;
    ControlEdit controlEdit = ControlEdit.firstLevelPanels;
    for (PScript s in models) {
      if (s.backend != null) backend = s.backend;
      if (s.routes != null) routes.addAll(s.routes);
      if (s.conversionErrorMessages != null)
        conversionErrorMessages.patterns.addAll(s.conversionErrorMessages.patterns);
      if (s.validationErrorMessages != null)
        validationErrorMessages.typePatterns.addAll(s.validationErrorMessages.typePatterns);
      if (s.isStatic != null) isStatic = s.isStatic;
      if (s.dataProviderIsDeclared) dataProvider = s.dataProvider;
      if (s.queryIsDeclared) query = s.query;
      if (s.panelStyle != null) panelStyle = s.panelStyle;
      if (s.writingStyle != null) writingStyle = s.writingStyle;
      if (s.controlEdit != null) controlEdit = s.controlEdit;
      _rootModel = PScript(
        name: name,
        backend: backend,
        routes: routes,
        id: id,
        conversionErrorMessages: conversionErrorMessages,
        validationErrorMessages: validationErrorMessages,
        isStatic: isStatic,
        query: query,
        dataProvider: dataProvider,
        controlEdit: controlEdit,
        panelStyle: panelStyle,
        writingStyle: writingStyle,
      );
    }
  }
}

final Precept _precept = Precept();

Precept get precept => _precept;

PScript script = _precept._rootModel;
