import 'dart:io';

import 'package:takkan_backend/backend/app/app_config_loader.dart';
import 'package:takkan_script/schema/schema.dart';

import 'generator/back4app/schema_generator/schema_generator.dart';

void main(List<String> arguments) async {
  stdout.writeln(
      "Starting server code generator  with args: ${arguments.join('\n')}");
  final args = GeneratorArgs(args: arguments);
  if (args.missingKeys.isNotEmpty) {
    final String msg =
        'code generation failed.  The following key(s) are missing as arguments:\n${args.missingKeys.join('\n')} ';
    final rawArgs = args.args.raw.join('\n');
    final String passed = 'The following arguments were passed: \n$rawArgs';
    // ignore: avoid_print
    stdout.writeln('msg\n\n$passed');
    throw Exception(msg);
  }
  stdout.writeln('Code generator will output to: ${args.serverCodeDir} ');

  final generator = SchemaGenerator2();
  generator.generateCode(schemaVersions: await extractSchemas(args));
  final outputDir = Directory(args.serverCodeDir);
  final outputCodeDir = Directory('${outputDir.path}/cloud');
  if (!outputCodeDir.existsSync()) {
    await outputCodeDir.create(recursive: true);
  }
  await generator.writeFiles(outputCodeDir);
  // ignore: avoid_print
  stdout.writeln(
      'Server code generation complete.\n\nTo deploy code, invoke the following commands from a terminal:\n\ncd ${args.serverCodeDir}/cloud\nb4a deploy\n\n');
}

/// Extracts Schema instances from the target app's loaders
///
/// ** THIS DOES NOT WORK AS IT SHOULD - IT DOES EXTRACT, BUT DOES NOT YET PROVIDE A LIST STRUCTURED AS FOLLOWS:**
/// https://gitlab.com/takkan/takkan_server_code_generator/-/issues/13
///
/// - Each version should be a already merged / combined if it is defined in multiple parts
/// - List is in version order with most recent version first (at index 0)
Future<List<Schema>> extractSchemas(GeneratorArgs args) async {
  final targetProject = Directory('${args.targetProject}/exported_schemas');
  const JsonFileLoader loader = DefaultJsonFileLoader();
  final exported = targetProject
      .listSync(followLinks: false)
      .where((element) => element.path.split('/').last.startsWith('schema'))
      .map((file) => loader.loadFile(filePath: file.path));

  final List<Map<String, dynamic>> json = await Future.wait(exported);
  return json.map((e) => Schema.fromJson(e)).toList();
}

/// This should be in a utils package somewhere, it is used in takkan_server_code_generator and takkan_dev_app
class Args {
  Args({required List<String> args, List<String> requiredKeys = const []})
      : raw = List<String>.from(args) {
    for (final String element in args) {
      final a = element.split('=');
      mappedArgs[a[0]] = a[1];
    }
    validatePresent(keys: requiredKeys);
  }

  final Map<String, String> mappedArgs = {};
  final List<String> raw;
  final List<String> missingKeys = List.empty(growable: true);

  List<String> validatePresent({required List<String> keys}) {
    for (final String key in keys) {
      if (!mappedArgs.containsKey(key)) {
        missingKeys.add(key);
      }
    }
    return missingKeys;
  }
}

class GeneratorArgs {
  GeneratorArgs({required List<String> args})
      : args = Args(
            args: args, requiredKeys: [serverCodeDirKey, targetProjectRoot]);
  static const String serverCodeDirKey = 'serverCodeDir';
  static const String targetProjectRoot = 'targetProject';
  final Args args;

  List<String> get missingKeys => args.missingKeys;

  String get serverCodeDir => args.mappedArgs[serverCodeDirKey]!;

  String get targetProject => args.mappedArgs[targetProjectRoot]!;
}
