import 'dart:io';

import 'package:precept_script/loader/loaders.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_server_code_generator/generator/back4app/back4app_schema_generator.dart';
import 'package:precept_server_code_generator/target/app/loaders.dart';

void main(List<String> arguments) async {
  print ("Starting server code generator  with args: ${arguments.join('\n')}");
  final args = GeneratorArgs(args: arguments);
  if (args.missingKeys.isNotEmpty) {
    final String msg =
        'code generation failed.  The following key(s) are missing as arguments:\n${args
        .missingKeys.join('\n')} ';
    final rawArgs = args.args.raw.join('\n');
    final String passed = "The following arguments were passed: \n$rawArgs";
    print('msg\n\n$passed');
    throw Exception(msg);
  }
  print('Code generator will output to: ${args.serverCodeDir}');

  final generator = Back4AppSchemaGenerator();
  generator.generateCode(schemas: await extractSchemas());
  final outputDir=Directory(args.serverCodeDir);
  if(!(await outputDir.exists())){
    await outputDir.create(recursive: true);
  }
  await generator.writeFiles(outputDir);
  print('Server code generation complete, see directory: ${args.serverCodeDir}');
}

/// Extracts PSchema instances from the target app's loaders
Future<List<PSchema>> extractSchemas() async {
  final List<PSchema> schemas = List.empty(growable: true);
  for (PreceptLoader loader in loaders) {
    final PScript script = await loader.load();
    schemas.add(script.schema);
    script.init();
  }
  return schemas;
}

/// This should be in a utils package somewhere, it is used in precept_server_code_generator and precept_dev_app
class Args {
  final Map<String, String> mappedArgs = {};
  final List<String> raw;
  final List<String> missingKeys = List.empty(growable: true);

  Args({required List<String> args, List<String> requiredKeys = const []})
      : raw=List<String>.from(args) {
    for (String element in args) {
      final a = element.split('=');
      mappedArgs[a[0]] = a[1];
    }
    validatePresent(keys: requiredKeys);
  }

  List<String> validatePresent({required List<String> keys}) {
    for (String key in keys) {
      if (!mappedArgs.containsKey(key)) {
        missingKeys.add(key);
      }
    }
    return missingKeys;
  }
}

class GeneratorArgs {
  static final String serverCodeDirKey = 'serverCodeDir';
  final Args args;

  GeneratorArgs({required List<String> args})
      : args = Args(args: args, requiredKeys: [serverCodeDirKey]);

  List<String> get missingKeys => args.missingKeys;

  String get serverCodeDir => args.mappedArgs[serverCodeDirKey]!;
}
