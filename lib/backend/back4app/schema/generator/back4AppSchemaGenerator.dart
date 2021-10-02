import 'dart:convert';

import 'package:precept_back4app_backend/backend/back4app/schema/generator/integerValidations.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';

abstract class BackendSchemaGenerator {}

abstract class GeneratedFile {
  final String fileName;

  GeneratedFile({required this.fileName});

  List<String> get lines => content.split('\n');

  String get content;
}

class JavaScriptFile extends GeneratedFile {
  final String content;

  JavaScriptFile({required String fileName, required this.content})
      : super(
          fileName: fileName,
        );
}

class JsonFile extends GeneratedFile {
  final Map<String, dynamic> data;

  JsonFile({required String fileName, required this.data})
      : super(
          fileName: fileName,
        );

  @override
  String get content => json.encode(data);
}

/// Generates Back4App Cloud Code files
/// [main] and [files] are only valid after [generate] has been invoked
class Back4AppSchemaGenerator implements BackendSchemaGenerator {
  final List<GeneratedFile> files = List.empty(growable: true);
  late final GeneratedFile main;
  final Map<String, dynamic> packageJson = Map();

  generate({required PSchema pSchema}) {
    _validationFunctions(pSchema: pSchema);
  }

  _validationFunctions({required PSchema pSchema}) {
    files.add(_createIntegerValidationFile());
    files.add(_createStringValidationFile());
  }
}

GeneratedFile _createStringValidationFile() {
  final StringBuffer buf = StringBuffer();
  final List<String> exports = List.empty(growable: true);
  return JavaScriptFile(
      fileName: 'stringValidation.js', content: buf.toString());
}

GeneratedFile _createIntegerValidationFile() {
  final StringBuffer buf = StringBuffer();
  final List<String> exports = List.empty(growable: true);
  ValidateInteger.values.forEach((element) {
    _validationFunction(
      buf: buf,
      validationEnum: element,
      function: integerFunction(element),
      exports: exports,
    );
  });
  _retrieveValue(buf: buf, type: 'integer', parse: 'parseInt');

  /// extract exports;
  buf.writeln('module.exports = {');
  buf.writeln(exports.join(',\n'));
  buf.writeln('}');
  return JavaScriptFile(
      fileName: 'integerValidation.js', content: buf.toString());
}

/// [validationEnum] is not typesafe.  There does not appear to be an 'isEnum' type check available in Dart
/// Data type is used for file names etc, may not exactly match the real data type
/// as naming of validationEnum is independent of backend
void _validationFunction(
    {required StringBuffer buf,
    required Object validationEnum,
    required function,
    required List<String> exports}) {
  if (!_checkType(validationEnum)) {
    throw PreceptException(
        '${validationEnum.runtimeType} is not an accepted Validation enum');
  }
  final validation = validationEnum.toString().split('.');
  final String functionName = validation[1];
  final dataType = validation[0].replaceFirst('Validate', '').toLowerCase();

  buf.writeln('function $functionName(request, field, param){');
  buf.writeln('  let value=${dataType}Value(request,field);');
  buf.writeln('  if ($function) return;');
  buf.writeln('  throw \'validation\';');
  buf.writeln('}');
  buf.writeln();
  exports.add('  $functionName');
}

_retrieveValue(
    {required StringBuffer buf, required String type, required String parse}) {
  buf.writeln('function ${type}Value(request, field){');
  buf.writeln('  return $parse(request.object.get(field));');
  buf.writeln('}');
  buf.writeln();
}

bool _checkType(Object candidate) {
  switch (candidate.runtimeType) {
    case ValidateInteger:
      return true;
    default:
      return false;
  }
}

//object.save (validation and ACL)

// roles

// CLP
