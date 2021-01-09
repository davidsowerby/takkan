import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:precept_backend/backend/backendLibrary.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_client/app/loader.dart';
import 'package:precept_client/app/router.dart';
import 'package:precept_client/binding/converter.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/library/particleLibrary.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/error.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/script.dart';

/// Loads the Precept models and initialises various parts of Precept
///
/// Considered having separate init calls for things like libraries, but the order of initialisation
/// is relevant in some cases - so it is just easier to put it all in one place.
///
/// Is constructed as a singleton
///
/// [init] must be called before the app is run
class Precept {
  final List<PScript> models = List();

  Precept();

  init(
      {List<Function()> injectionBindings = const [],
      bool includePreceptDefaults = true,
      Map<String, Widget Function(PPage)> pageLibraryEntries,

  Map<Type, Widget Function(PPart, ModelConnector)> particleLibraryEntries,
      Widget Function(PError) errorPage,
      Map<String, BackendDelegate Function(PBackend)> backendLibraryEntries,
      List<PreceptLoader> loaders = const []}) async {
if (includePreceptDefaults || injectionBindings == null || injectionBindings.isEmpty) {
preceptDefaultInjectionBindings();
}
await loadModels(loaders: loaders);
backendLibrary.init(entries: backendLibraryEntries);
particleLibrary.init(entries: particleLibraryEntries);

router.init(scripts: precept.models);
}

// TODO error handling, loader may fail
  loadModels({@required List<PreceptLoader> loaders}) async {
    logType(this.runtimeType).d("Loading models");
    List<Future<PScript>> modelFutures = List();
    for (PreceptLoader loader in loaders) {
      modelFutures.add(loader.load());
    }
    final m = await Future.wait(modelFutures);
    logType(this.runtimeType).d("All models loaded");
    models.addAll(m);
    for (var model in models){
      model.init();
    }
    router.init(scripts: models);
  }
}

final Precept _precept = Precept();

Precept get precept => _precept;
