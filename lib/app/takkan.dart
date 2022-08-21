import 'package:flutter/material.dart';
import 'package:takkan_client/app/router.dart';
import 'package:takkan_client/data/binding/connector.dart';
import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/inject/modules.dart';
import 'package:takkan_client/library/part_library.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/loader/assembler.dart';
import 'package:takkan_script/loader/loaders.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;
import 'package:takkan_script/part/part.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/walker.dart';

// TODO error handling, loader may fail

/// Loads the Takkan models and initialises various parts of Takkan
///
/// Considered having separate init calls for things like libraries, but the order of initialisation
/// is relevant in some cases - so it is just easier to put it all in one place.
///
/// Is constructed as a singleton
///
/// [init] must be called before the app is run
class Takkan {
  late Script _rootModel;
  late Map<String, dynamic> _jsonConfig;
  bool _isReady = false;
  final List<Function()> _readyListeners = List.empty(growable: true);
  final List<Function()> _scriptReloadListeners = List.empty(growable: true);
  final bool useDefaultDataProvider;
  late List<TakkanLoader> _loaders;
  late Map<Type, Widget Function(Part, ModelConnector)> _particleLibraryEntries;
  late List<String> commandLineArguments;
  final DocumentCache cache = DocumentCache();

  Takkan({this.useDefaultDataProvider = true});

  init({
    required List<String> commandLineArguments,
    bool includeTakkanDefaults = true,
    Map<String, Widget Function(PageConfig.Page)> pageLibraryEntries = const {},
    Map<Type, Widget Function(Part, ModelConnector)> particleLibraryEntries =
        const {},
    List<TakkanLoader> loaders = const [],
    List<void Function()> injectionBindings = const [],
    List<Route<dynamic> Function(RouteSettings, BuildContext)> routersBefore =
        const [],
    List<Route<dynamic> Function(RouteSettings, BuildContext)> routersAfter =
        const [],
  }) async {
    this.commandLineArguments = commandLineArguments;
    WidgetsFlutterBinding.ensureInitialized();

    appConfigFromAssetBindings();



    if (includeTakkanDefaults || injectionBindings.isEmpty) {
      takkanDefaultInjectionBindings();
    }



    _loaders = loaders;
    _particleLibraryEntries = particleLibraryEntries;
    router.init(routersBefore: routersBefore, routersAfter: routersAfter);
    await getIt.allReady();
    await loadScripts(loaders);
    await _doAfterLoad();
  }

  /// This is public for testing purposes only.
  loadScripts(List<TakkanLoader> loaders) async {
    _rootModel = await ScriptAssembler().assemble(loaders: loaders);
    _rootModel.init();
  }

  _doAfterLoad() async {
    await _loadSchemas();
    library.init(entries: _particleLibraryEntries);


    _isReady = true;
    notifyReadyListeners();
    notifyScriptReloadListeners();
  }

  reload() async {
    _isReady = false;
    notifyReadyListeners();
    await loadScripts(_loaders);
    await _doAfterLoad();
  }

  addScriptReloadListener(Function() listener) {
    _scriptReloadListeners.add(listener);
  }

  /// Walks the Script to find any declared [SchemaSource] instances, and calls them to be loaded,
  /// if they are not already loaded
  Future<bool> _loadSchemas() async {
    final visitor = DataProviderVisitor();
    _rootModel.walk([visitor]);
    final List<DataProvider> requireLoading = List.empty(growable: true);

    /// select those which have no schema, for loading
    for (DataProvider provider in visitor.dataProviders) {
      requireLoading.add(provider);
    }

    if (requireLoading.length > 0) {
      for (DataProvider provider in requireLoading) {
        RestTakkanLoader loader = RestTakkanLoader();
      }
    }
    return true;
  }

  /// Call is not actioned if Takkan already in ready state
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



}

final Takkan _takkan = Takkan();

Takkan get takkan => _takkan;

Script script = _takkan._rootModel;

/// When used with [script.walk] returns all [PDataProvider] instances
class DataProviderVisitor implements ScriptVisitor {
  List<DataProvider> dataProviders = List.empty(growable: true);

  @override
  step(Object entry) {
    if (entry is DataProvider) {
      dataProviders.add(entry);
    }
  }
}
