import 'dart:convert';
import 'dart:io';

import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/script/constants.dart';

/// The default is to hold app configuration in a file *precept.json* in the project root.
///
/// Except for testing, any deviation from this convention is discouraged, as Precept
/// assumes that is where the configuration is.
///
/// It is therefore usually unnecessary to specify [fileName], except when testing
///
///
/// If loading through a Flutter client, this loader will not work, use the
/// JSONAssetLoader in the *precept_client* package instead
class AppConfigFileLoader {
  final String? fileName;

  const AppConfigFileLoader({this.fileName});

  /// If [returnEmptyIfAbsent] is true, a missing *precept.json* returns an empty
  /// [AppConfig] - if false, a [PreceptException] is thrown if no *precept.json*
  /// exists in [fileName]
  Future<AppConfig> load({
    String currentStage = notSet,
    bool returnEmptyIfAbsent = false,
  }) async {
    final f = (fileName == null)
        ? File('${Directory.current.path}/precept.json')
        : File(fileName!);
    if (!f.existsSync()) {
      if (returnEmptyIfAbsent) {
        return AppConfig(
          currentStage: currentStage,
          data: Map(),
        );
      } else {
        throw PreceptException('There is no file at ${f.path}');
      }
    }
    final content = f.readAsStringSync();
    final j = json.decode(content);
    return AppConfig(
      currentStage: currentStage,
      data: j,
    );
  }
}
