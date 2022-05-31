import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/converter/conversion_error_messages.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/loader/loaders.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/schema/validation/validation_error_messages.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';

class ScriptAssembler {
  /// Loads all requested [Script], and merges them into a single [_rootModel]
  Future<Script> assemble({required List<TakkanLoader> loaders}) async {
    logType(runtimeType).d('Loading models');
    final List<Future<Script>> modelFutures = List.empty(growable: true);
    for (TakkanLoader loader in loaders) {
      modelFutures.add(loader.load());
    }
    final m = await Future.wait(modelFutures);
    logType(runtimeType).d('All models loaded');
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
  Script _mergeModels(List<Script> models) {
    final Script firstModel = models[0];
    final String name = firstModel.name;
    final String id = firstModel.pid ?? name;
    final Version version = firstModel.version;
    final List<Page> pages = List.empty(growable: true);
    final ConversionErrorMessages conversionErrorMessages =
        ConversionErrorMessages(patterns: Map());
    final ValidationErrorMessages validationErrorMessages =
        ValidationErrorMessages(typePatterns: Map());
    DataProvider? dataProvider;
    Query? query;
    ControlEdit controlEdit = ControlEdit.firstLevelPanels;
    for (Script s in models) {
      pages.addAll(s.pages);
      conversionErrorMessages.patterns
          .addAll(s.conversionErrorMessages.patterns);
      validationErrorMessages.typePatterns
          .addAll(s.validationErrorMessages.typePatterns);
      if (s.dataProviderIsDeclared) dataProvider = s.dataProvider;
      // if (s.queryIsDeclared) data-select = s.data-select;  TODO: queryIsDeclared was removed
      controlEdit = s.controlEdit;
    }
    return Script(
      name: name,
      schema: Schema(
        name: 'dummy - move from data provider',
        version: const Version(number: -1),
      ),
      pages: pages,
      version: version,
      conversionErrorMessages: conversionErrorMessages,
      validationErrorMessages: validationErrorMessages,
      dataProvider: dataProvider,
      controlEdit: controlEdit,
    );
  }
}
