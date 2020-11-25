import 'package:flutter/foundation.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/loader.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/precept/router.dart';

/// [init] must be called before the app is run
class Precept {
  final List<PModel> models = List();

  Precept();

  init(
      {List<Function()> injectionBindings = const [],
      bool includePreceptDefaults = true,
      List<PageLibraryModule> pageModules,
      List<PreceptLoader> loaders = const []}) async {
    if (includePreceptDefaults || injectionBindings == null || injectionBindings.isEmpty) {
      preceptDefaultInjectionBindings();
    }
    await loadModels(loaders: loaders);
    pageLibrary.init(modules: pageModules, useDefault: includePreceptDefaults);
    router.init(models: precept.models);
  }

// TODO error handling, loader may fail
  loadModels({@required List<PreceptLoader> loaders}) async {
    getLogger(this.runtimeType).d("Loading models");
    List<Future<PModel>> modelFutures = List();
    for (PreceptLoader loader in loaders) {
      modelFutures.add(loader.load());
    }
    final m = await Future.wait(modelFutures);
    getLogger(this.runtimeType).d("All models loaded");
    models.addAll(m);
    router.init(models: models);
    partLibrary.init(models: models);
  }
}

final Precept _precept=Precept();
Precept get precept => _precept;