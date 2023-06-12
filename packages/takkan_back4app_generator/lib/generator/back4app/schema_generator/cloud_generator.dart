import 'dart:io';

import 'package:takkan_schema/schema/schema.dart';

import '../../generated_file.dart';
import '../api_file.dart';
import '../b4a_schema_file.dart';
import '../function_file.dart';
import '../main_file.dart';
import '../server_code_structure.dart';
import '../store_file.dart';
import '../trigger_file.dart';

abstract class CloudGenerator {}

class Back4AppCloudGenerator implements CloudGenerator {
  final List<JavaScriptFile> jsFiles = List.empty(growable: true);
  final Back4AppSchema b4aSchema = const Back4AppSchema();

  /// [schemaVersions] is a list of [Schema] versions. They may be in any order,
  /// as they are sorted into descending version number order before use.
  /// that is, newest first.  This call generates the content of [jsFiles], but does not
  /// create physical files.
  ///
  /// **NOTE** 'User and 'Role' excluded for now, see https://gitlab.com/takkan/takkan_design/-/issues/34
  void generateCode({required List<Schema> schemaVersions}) {
    final List<Schema> versions=schemaVersions;
    versions.sort((a,b) => b.version.number.compareTo(a.version.number));

    _initSchemas(versions);
    final Set<String> documentNameSet = versions
        .expand((e) => e.documents.keys)
        .where((element) => element != 'User' && element != 'Role')
        .toSet();
    for (final String documentClassName in documentNameSet) {
      jsFiles.add(TriggerJavaScriptFile(documentClassName: documentClassName));
      jsFiles.add(APIJavaScriptFile(documentClassName: documentClassName));
      jsFiles.add(FunctionJavaScriptFile(documentClassName: documentClassName));
    }
    jsFiles.add(StoreJavaScriptFile());
    jsFiles.add(B4ASchemaJavaScriptFile());
    for (final jsFile in jsFiles) {
      jsFile.writeToBuffer(schemaVersions: versions);
    }

    /// The Back4App schema itself
    b4aSchema.generate(schemaVersions: schemaVersions);
  }

  void _initSchemas(List<Schema> schemaVersions) {
    for (final schema in schemaVersions) {
      schema.init();
    }
  }

  /// see  https://takkan.org/docs/developer-guide/back4app-implementation#initial-deployment-process
  ///
  /// Generates all files into [outputDir], and if [autoDeploy] is true, uploads them to Back4App
  Future<bool> initialDeployment({
    required List<Schema> schemaVersions,
    required Directory outputDir,
    bool autoDeploy = true,
  }) async {
    generateCode(schemaVersions: schemaVersions);
    final ServerCodeStructure serverCodeStructure =
        ServerCodeStructure(outputDir: outputDir);

    final mainJs = MainJavaScriptFile();
    final List<Future<File>> futures = List.empty(growable: true);
    for (final sourceFile in jsFiles) {
      futures.add(serverCodeStructure.writeGeneratedFile(
          sourceFile: sourceFile, mainJs: mainJs));
    }
    futures.add(serverCodeStructure.writeMainFile(mainJs,outputDir));

    await Future.wait(futures);
    if (autoDeploy) {
      // deploy(outputDir);
    }
    return true;
    // throw UnimplementedError();
  }

  /// see https://takkan.org/docs/developer-guide/back4app-implementation#update-deployment-process
  ///
  /// - First step generates server schema, framework. *main.js* must continue to reflect all currently deployed code,
  /// but not new classes yet. At this step, *main.js* does not need to change unless there is a new framework file
  /// - Second step generates the rest, which will update main.js if needed (usually a new Class)
  Future<bool> updateDeployment({
    required List<Schema> schemaVersions,
    required Directory outputDir,
    bool autoDeploy = true,
  }) {
    generateCode(schemaVersions: schemaVersions);
    throw UnimplementedError();
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
