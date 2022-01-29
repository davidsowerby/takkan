import 'dart:convert';
import 'dart:io';

import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/validation/result.dart';
import 'package:precept_script/validation/validate.dart';

abstract class BackendSchemaGenerator {}

abstract class GeneratedFile {
  final String fileName;

  GeneratedFile({required this.fileName});

  List<String> get lines => content.split('\n');

  String get content;

  Future<File> writeFile(Directory outputDirectory) async {
    final File outputFile = File('${outputDirectory.path}/$fileName');
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await outputFile.create();
    return outputFile.writeAsString(content, flush: true);
  }
}

class JavaScriptFile extends GeneratedFile {
  @override
  final String content;
  final String dataTypeLabel;

  JavaScriptFile(
      {required String fileName,
      required this.dataTypeLabel,
      required this.content})
      : super(fileName: fileName);
}

class JSONFile extends GeneratedFile {
  final Map<String, dynamic> json;

  JSONFile({required String fileName, required this.json})
      : super(fileName: fileName);

  @override
  String get content => jsonEncode(json);
}

class JsonFile extends GeneratedFile {
  final Map<String, dynamic> data;

  JsonFile({required String fileName, required this.data})
      : super(fileName: fileName);

  @override
  String get content => json.encode(data);
}

/// Generates Back4App Cloud Code files
/// [main] and [files] are only valid after [generate] has been invoked
class Back4AppSchemaGenerator implements BackendSchemaGenerator {
  final Map<String, GeneratedFile> files = {};

  /// Writes all the [files] to [outputDirectory].  This is usually the directory you use for
  /// uploading cloud code to Back4App
  Future<List<File>> writeFiles(Directory outputDirectory) async {
    final List<Future<File>> futures = List.empty(growable: true);
    for (GeneratedFile gf in files.values) {
      futures.add(gf.writeFile(outputDirectory));
    }
    return Future.wait(futures);
  }

  generate({required PSchema pSchema}) {
    _validationFunctions(pSchema: pSchema);
    _main(pSchema: pSchema);
    _packageJson();
  }

  GeneratedFile get stringValidation =>
      _generatedFileProperty('stringValidation.js');

  GeneratedFile get integerValidation =>
      _generatedFileProperty('integerValidation.js');

  GeneratedFile get main => _generatedFileProperty('main.js');

  GeneratedFile get packageJson => _generatedFileProperty('package.json');

  GeneratedFile _generatedFileProperty(String fileName) {
    final f = files[fileName];
    if (f != null) {
      return f;
    }
    throw Exception('GeneratedFile for $fileName not found');
  }

  _packageJson() {
    final JSONFile file = JSONFile(fileName: 'package.json', json: {
      "dependencies": {"validator": "13.6.0"}
    });
    files[file.fileName] = file;
  }

  _main({required PSchema pSchema}) {
    final StringBuffer buf = StringBuffer();

    /// This relies on validation files being generated first
    for (GeneratedFile gf in files.values) {
      final jf = gf as JavaScriptFile;
      buf.writeln(
          "var validate${jf.dataTypeLabel} = require('./${jf.fileName}');");
    }
    buf.writeln();
    for (PDocument doc in pSchema.documents.values) {
      buf.writeln('Parse.Cloud.beforeSave("${doc.name}", (request) => {');
      doc.fields.forEach((fieldName, field) {
        for (V v in field.validations) {
          final ref = validationRef(v);
          final paramsList = ref.params.values.join(',');
          final dataTypeLabel = field.runtimeType.toString().substring(1);
          buf.writeln(
              '  validate$dataTypeLabel.${ref.name}(request,\'$fieldName\',$paramsList);');
        }
      });
      buf.writeln('})');
    }

    final mainJs = JavaScriptFile(
      fileName: 'main.js',
      dataTypeLabel: '',
      content: buf.toString(),
    );
    files[mainJs.fileName] = mainJs;
  }

  _validationFunctions({required PSchema pSchema}) {
    final intVal = _createValidationFile(
      cases: VInteger.refs(),
      dataTypeLabel: 'Integer',
    );
    files[intVal.fileName] = intVal;
    final stringVal = _createValidationFile(
      cases: VString.refs(),
      dataTypeLabel: 'String',
      requireModules: ['validator'],
    );
    files[stringVal.fileName] = stringVal;
  }
}

/// For each option within a V (VInteger, VString etc) we need to generate javascript
/// to represent that function
///
/// [cases] are all the VResultRef instances for the [V] (eg VInteger)
GeneratedFile _createValidationFile({
  required List<VResultRef> cases,
  required String dataTypeLabel,
  List<String> requireModules = const [],
}) {
  final StringBuffer buf = StringBuffer();
  final List<String> exports = List.empty(growable: true);

  for (var element in requireModules) {
    buf.writeln("var val = require('$element');");
  }

  if (requireModules.isNotEmpty) {
    buf.writeln();
  }

  int c = 0;
  for (var element in cases) {
    final String functionName = element.name;
    _validationFunction(
      buf: buf,
      dataTypeLabel: dataTypeLabel.toLowerCase(),
      functionCode: element.javaScript,
      exports: exports,
      functionName: functionName,
      params: element.params.keys.toList(),
    );
    c++;
  }

  _retrieveValue(buf: buf, dataTypeLabel: dataTypeLabel);

  /// extract exports;
  buf.writeln('module.exports = {');
  buf.writeln(exports.join(',\n'));
  buf.writeln('}');
  return JavaScriptFile(
      dataTypeLabel: dataTypeLabel,
      fileName: '${dataTypeLabel.toLowerCase()}Validation.js',
      content: buf.toString());
}

/// [validationEnum] is not typesafe.  There does not appear to be an 'isEnum' type check available in Dart
/// Data type is used for file names etc, may not exactly match the real data type
/// as naming of validationEnum is independent of backend
void _validationFunction(
    {required StringBuffer buf,
    required String functionCode,
    required String functionName,
    required String dataTypeLabel,
    required List<String> params,
    required List<String> exports}) {
  final p = params.join(',');
  buf.writeln('function $functionName(request, field, $p){');
  buf.writeln('  let value=${dataTypeLabel}Value(request,field);');
  buf.writeln('  if ($functionCode) return;');
  buf.writeln('  throw \'validation\';');
  buf.writeln('}');
  buf.writeln();
  exports.add('  $functionName');
}

_retrieveValue({required StringBuffer buf, required String dataTypeLabel}) {
  buf.writeln('function ${dataTypeLabel.toLowerCase()}Value(request, field){');
  if (dataTypeLabel.toLowerCase() == 'integer') {
    buf.writeln('  return parseInt(request.object.get(field));');
  } else {
    buf.writeln('  return request.object.get(field);');
  }
  buf.writeln('}');
  buf.writeln();
}

//object.save (validation and ACL)

// roles

// CLP
