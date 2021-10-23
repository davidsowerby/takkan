import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/converter/conversionErrorMessages.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/loader/loaders.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/validation/validationErrorMessages.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';

class ScriptAssembler {
  /// Loads all requested [PScript], and merges them into a single [_rootModel]
  Future<PScript> assemble({required List<PreceptLoader> loaders}) async {
    logType(this.runtimeType).d("Loading models");
    List<Future<PScript>> modelFutures = List.empty(growable: true);
    for (PreceptLoader loader in loaders) {
      modelFutures.add(loader.load());
    }
    final m = await Future.wait(modelFutures);
    logType(this.runtimeType).d("All models loaded");
    if (m.length > 1) {
      return _mergeModels(m);
    } else {
      return m[0];
    }
  }

  /// Merging is carried out in the order specified in [models], and follows these principles:
  /// - for single value properties (such as authenticator), a non-null value overwrites a previous value
  /// - for multi-value properties (lists and maps), values are added to previous values.  This means that
  /// later map values will overwrite earlier entries with the same keys.
  /// - [ConversionErrorMessages] and [ValidationErrorMessages] are merged as maps
  /// - name, id, version and versionLabel are always taken from the first entry in [models]
  ///
  PScript _mergeModels(List<PScript> models) {
    final PScript firstModel = models[0];
    String name = firstModel.name;
    String id = firstModel.pid ?? name;
    PVersion version = firstModel.version;
    Map<String, PPage> routes = Map();
    final ConversionErrorMessages conversionErrorMessages =
        ConversionErrorMessages(patterns: Map());
    final ValidationErrorMessages validationErrorMessages =
        ValidationErrorMessages(typePatterns: Map());
    IsStatic isStatic = IsStatic.inherited;
    PDataProvider? dataProvider;
    PQuery? query;
    ControlEdit controlEdit = ControlEdit.firstLevelPanels;
    for (PScript s in models) {
      routes.addAll(s.routes);
      conversionErrorMessages.patterns
          .addAll(s.conversionErrorMessages.patterns);
      validationErrorMessages.typePatterns
          .addAll(s.validationErrorMessages.typePatterns);
      isStatic = s.isStatic;
      if (s.dataProviderIsDeclared) dataProvider = s.dataProvider;
      if (s.queryIsDeclared) query = s.query;
      controlEdit = s.controlEdit;
    }
    return PScript(
      name: name,
      routes: routes,
      version: version,
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
