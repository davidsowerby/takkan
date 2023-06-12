import 'dart:io';

import '../generated_file.dart';
import 'api_file.dart';
import 'b4a_schema_file.dart';
import 'function_file.dart';
import 'main_file.dart';
import 'store_file.dart';
import 'trigger_file.dart';

class ServerCodeStructure {
  ServerCodeStructure({required this.outputDir});

  final Map<String, String> frameworkFiles = {
    'framework.js':
        'lib/generator/back4app/schema_generator/javascript/framework.js'
  };

  final Directory outputDir;

  String get configPath => 'config';

  Directory get configDir => Directory('${outputDir.path}/$configPath');

  String get schemaPath => 'schema';

  Directory get schemaDir => Directory('${outputDir.path}/$schemaPath');

  String get classesPath => 'classes';

  Directory get classesDir => Directory('${outputDir.path}/$classesPath');

  String classDir({required String documentClassName}) {
    return '$classesPath/$documentClassName';
  }

  String functionPath({required String documentClassName}) {
    return classDir(documentClassName: documentClassName);
  }

  String apiPath({required String documentClassName}) {
    return classDir(documentClassName: documentClassName);
  }

  String triggerPath({required String documentClassName}) {
    return classDir(documentClassName: documentClassName);
  }

  File functionFile(String documentClassName) {
    return File(
        '${outputDir.path}/$classesPath/$documentClassName/functions.js');
  }

  /// Returns the relative path of f in relation to [outputDir].  Used for 'require'
  /// statements
  String _relativePath(File f) {
    final outPath = outputDir.path;
    final relativePath = f.path.replaceFirst(outPath, '.');
    return relativePath;
  }

  File apiFile(String documentClassName) {
    return File('${outputDir.path}/$classesPath/$documentClassName/api.js');
  }

  File triggerFile(String documentClassName) {
    return File(
        '${outputDir.path}/$classesPath/$documentClassName/triggers.js');
  }

  File b4aSchemaFile() {
    return File('${outputDir.path}/b4a_schema.js');
  }

  File storeFile() {
    return File('${outputDir.path}/store.js');
  }

  Future<List<Future<File>>> copyFrameworkFiles() async {
    final List<Future<File>> futures = List.empty(growable: true);
    frameworkFiles.forEach((targetFilename, sourcePath) {
      final File source = File(sourcePath);
      futures.add(source.copy('${outputDir.path}/$targetFilename'));
    });
    return futures;
  }

  /// Writes [sourceFile] to disk.  Updates the [mainJs] with 'requires' statement where required
  Future<File> writeGeneratedFile({
    required JavaScriptFile sourceFile,
    required MainJavaScriptFile mainJs,
  }) async {
    switch (sourceFile.runtimeType) {
      case FunctionJavaScriptFile:
        {
          final jsf = sourceFile as FunctionJavaScriptFile;
          return _writeFile(
            outputFile: functionFile(jsf.documentClassName),
            data: jsf.buf.toString(),
          );
        }
      case APIJavaScriptFile:
        {
          final jsf = sourceFile as APIJavaScriptFile;
          mainJs.requires.add(_relativePath(apiFile(jsf.documentClassName)));
          return _writeFile(
            outputFile: apiFile(jsf.documentClassName),
            data: jsf.buf.toString(),
          );
        }
      case TriggerJavaScriptFile:
        {
          final jsf = sourceFile as TriggerJavaScriptFile;
          mainJs.requires
              .add(_relativePath(triggerFile(jsf.documentClassName)));
          return _writeFile(
            outputFile: triggerFile(jsf.documentClassName),
            data: jsf.buf.toString(),
          );
        }
      case B4ASchemaJavaScriptFile:
        {
          final jsf = sourceFile as B4ASchemaJavaScriptFile;
          mainJs.requires.add('./b4a_schema.js');
          return _writeFile(
            outputFile: b4aSchemaFile(),
            data: jsf.buf.toString(),
          );
        }

      case StoreJavaScriptFile:
        {
          final jsf = sourceFile as StoreJavaScriptFile;
          mainJs.requires.add('./store.js');
          return _writeFile(
            outputFile: storeFile(),
            data: jsf.buf.toString(),
          );
        }
    }
    throw UnsupportedError('Unrecognised JavaScriptFile');
  }

  Future<File> _writeFile(
      {required File outputFile, required String data}) async {
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await outputFile.create(recursive: true);
    return outputFile.writeAsString(data, flush: true);
  }

  Future<File> writeMainFile(MainJavaScriptFile mainJs, Directory outputDir) {
    return mainJs.writeFile(outputDir);
  }


}
