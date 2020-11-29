import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:precept_client/backend/backend.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/library/backendLibrary.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/loader.dart';
import 'package:precept_client/precept/model/backend.dart';
import 'package:precept_client/precept/model/error.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/precept/router.dart';

/// Loads the Precept models and initialises various parts of Precept
///
/// Considered having separate init calls for things like libraries, but the order of initialisation
/// is relevant in some cases - so it is just easier to put it all in one place.
///
/// Is constructed as a singleton
///
/// [init] must be called before the app is run
class Precept {
  final List<PModel> models = List();

  Precept();

  init(
      {List<Function()> injectionBindings = const [],
      bool includePreceptDefaults = true,
      Map<String, Widget Function(PPage)> pageLibraryEntries,
      Widget Function(PError) errorPage,
      Map<String, BackendDelegate Function(PBackend)> backendLibraryEntries,
      List<PreceptLoader> loaders = const []}) async {
    if (includePreceptDefaults || injectionBindings == null || injectionBindings.isEmpty) {
      preceptDefaultInjectionBindings();
    }
    await loadModels(loaders: loaders);
    backendLibrary.init();
    pageLibrary.init(entries: pageLibraryEntries, errorPage: errorPage);
    router.init(models: precept.models);
  }

// TODO error handling, loader may fail
  loadModels({@required List<PreceptLoader> loaders}) async {
    logType(this.runtimeType).d("Loading models");
    List<Future<PModel>> modelFutures = List();
    for (PreceptLoader loader in loaders) {
      modelFutures.add(loader.load());
    }
    final m = await Future.wait(modelFutures);
    logType(this.runtimeType).d("All models loaded");
    models.addAll(m);
    router.init(models: models);
    partLibrary.init(models: models);
  }
}

final Precept _precept = Precept();

Precept get precept => _precept;
