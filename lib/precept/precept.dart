import 'package:flutter/foundation.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/loader.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/precept/router.dart';

/// [init] must be called before the app is run
class Precept {
  final List<PModel> models = List();
  final List<PreceptLoader> loaders;

  Precept({@required this.loaders});

// TODO error handling, loader may fail
  init() async {
    List<Future<PModel>> modelFutures = List();
    for (PreceptLoader loader in loaders) {
      modelFutures.add(loader.load());
    }
    final m = await Future.wait(modelFutures);
    models.addAll(m);
    router.init(models: models);
    partLibrary.init(models: models);
  }
}

Precept get precept => inject<Precept>();



