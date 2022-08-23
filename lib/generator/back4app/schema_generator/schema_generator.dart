import 'dart:io';

import 'package:takkan_schema/schema/schema.dart';

import '../../generated_file.dart';
import '../api_file.dart';
import '../b4a_schema_file.dart';
import '../function_file.dart';
import '../main_file.dart';
import '../trigger_file.dart';

abstract class BackendSchemaGenerator {}

class SchemaGenerator2 implements BackendSchemaGenerator {
  final List<JavaScriptFile> files = List.empty(growable: true);
  final Back4AppSchema b4aSchema = const Back4AppSchema();

  /// [schemaVersions] must contain a list of [Schema] ordered by descending version number,
  /// that is, newest first.  This call generates the content of [files], but does not
  /// create physical files.
  ///
  /// **NOTE** 'User and 'Role' excluded for now, see https://gitlab.com/takkan/takkan_design/-/issues/34
  void generateCode({required List<Schema> schemaVersions}) {
    _initSchemas(schemaVersions);
    final Set<String> documentNameSet = schemaVersions
        .expand((e) => e.documents.keys)
        .where((element) => element != 'User' && element != 'Role')
        .toSet();
    for (final String documentClassName in documentNameSet) {
      files.add(TriggerJavaScriptFile(documentClassName: documentClassName));
      files.add(APIJavaScriptFile(documentClassName: documentClassName));
      files.add(FunctionJavaScriptFile(documentClassName: documentClassName));
    }
    files.add(B4ASchemaJavaScriptFile());
    for (final jsFile in files) {
      jsFile.writeToBuffer(schemaVersions: schemaVersions);
    }

    /// The Back4App schema itself
    b4aSchema.generate(schemaVersions: schemaVersions);
  }

  Future<List<File>> writeFiles(Directory outputDir) {
    final codeStructure =
        ServerCodeStructure(outputDir: outputDir, jsFiles: files);
    return codeStructure.writeFiles();
  }

  void _initSchemas(List<Schema> schemaVersions) {
    for (final schema in schemaVersions) {
      schema.init();
    }
  }
}

class ServerCodeStructure {
  ServerCodeStructure({required this.outputDir, required this.jsFiles});

  final List<JavaScriptFile> jsFiles;
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

  Future<List<File>> writeFiles() async {
    final List<Future<File>> futures = List.empty(growable: true);
    _writeGeneratedFiles(futures);
    _copyFrameworkFiles(futures);
    final files = await Future.wait(futures);
    return files;
  }

  Future<void> _copyFrameworkFiles(List<Future<File>> futures) async {
    frameworkFiles.forEach((targetFilename, sourcePath) {
      final File source = File(sourcePath);
      futures.add(source.copy('${outputDir.path}/$targetFilename'));
    });
  }

  Future<List<File>> _writeGeneratedFiles(List<Future<File>> futures) async {
    final MainJavaScriptFile main = MainJavaScriptFile();
    for (final JavaScriptFile jsFile in jsFiles) {
      switch (jsFile.runtimeType) {
        case FunctionJavaScriptFile:
          {
            final jsf = jsFile as FunctionJavaScriptFile;
            futures.add(
              _writeFile(
                outputFile: functionFile(jsf.documentClassName),
                data: jsf.buf.toString(),
              ),
            );
            break;
          }
        case APIJavaScriptFile:
          {
            final jsf = jsFile as APIJavaScriptFile;
            futures.add(
              _writeFile(
                outputFile: apiFile(jsf.documentClassName),
                data: jsf.buf.toString(),
              ),
            );
            main.requires.add(_relativePath(apiFile(jsf.documentClassName)));
            break;
          }
        case TriggerJavaScriptFile:
          {
            final jsf = jsFile as TriggerJavaScriptFile;
            futures.add(
              _writeFile(
                outputFile: triggerFile(jsf.documentClassName),
                data: jsf.buf.toString(),
              ),
            );
            main.requires
                .add(_relativePath(triggerFile(jsf.documentClassName)));
            break;
          }
        case B4ASchemaJavaScriptFile:
          {
            final jsf = jsFile as B4ASchemaJavaScriptFile;
            futures.add(
              _writeFile(
                outputFile: b4aSchemaFile(),
                data: jsf.buf.toString(),
              ),
            );
            main.requires.add('./b4a_schema.js');
            break;
          }
      }
    }
    main.writeToBuffer(schemaVersions: const []);
    futures.add(
      _writeFile(
          outputFile: File('${outputDir.path}/main.js'),
          data: main.buf.toString()),
    );
    return Future.wait(futures);
  }

  Future<File> _writeFile(
      {required File outputFile, required String data}) async {
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await outputFile.create(recursive: true);
    return outputFile.writeAsString(data, flush: true);
  }
}

/// This is what Back4App sets Role CLP to initially
const roleDefaultCLP = {
  'find': {'*': true, 'requiresAuthentication': true},
  'count': {'*': true, 'requiresAuthentication': true},
  'get': {'*': true, 'requiresAuthentication': true},
  'create': {'requiresAuthentication': true},
  'update': {},
  'delete': {},
  'addField': {},
  'protectedFields': {'*': []}
};

/// This is what Back4App sets User CLP to initially
const publicCLP = {
  'find': {'*': true},
  'count': {'*': true},
  'get': {'*': true},
  'create': {'*': true},
  'update': {'*': true},
  'delete': {'*': true},
  'addField': {'*': true},
  'protectedFields': {'*': []}
};

const userDefaultCLP = publicCLP;
