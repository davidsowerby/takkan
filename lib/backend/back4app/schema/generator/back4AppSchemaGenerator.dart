import 'dart:convert';

import 'package:precept_back4app_backend/backend/back4app/schema/generator/integerValidations.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/generator/stringValidations.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
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
    files.add(_createValidationFile(ValidateInteger.values));
    files.add(_createValidationFile(ValidateString.values));
  }
}

GeneratedFile _createStringValidationFile() {
  final StringBuffer buf = StringBuffer();
  final List<String> exports = List.empty(growable: true);
  return JavaScriptFile(
      fileName: 'stringValidation.js', content: buf.toString());
}

GeneratedFile _createValidationFile(List<Object> validationEnums) {
  final StringBuffer buf = StringBuffer();
  final List<String> exports = List.empty(growable: true);
  if (!_checkType(validationEnums[0])) {
    throw PreceptException(
        '${validationEnums[0].runtimeType} is not an accepted Validation enum');
  }

  if (validationEnums[0] is ValidateString) {
    buf.writeln("var val = require('validator');");
    buf.writeln();
  }
  String dataType = '?';
  int c = 0;
  validationEnums.forEach((element) {
    final validation = validationEnums[c].toString().split('.');
    final String functionName = validation[1];
    if (c == 0) {
      dataType = validation[c].replaceFirst('Validate', '').toLowerCase();
    }
    _validationFunction(
      buf: buf,
      dataType: dataType,
      functionCode: _validationFunctionCode(element),
      exports: exports,
      functionName: functionName,
    );
    c++;
  });

  _retrieveValue(buf: buf, type: dataType);

  /// extract exports;
  buf.writeln('module.exports = {');
  buf.writeln(exports.join(',\n'));
  buf.writeln('}');
  return JavaScriptFile(
      fileName: '${dataType}Validation.js', content: buf.toString());
}

/// Decide which lookup to use
String _validationFunctionCode(Object val) {
  switch (val.runtimeType) {
    case ValidateInteger:
      return integerFunctionCode(val as ValidateInteger);
    case ValidateString:
      return stringFunctionCode(val as ValidateString);
  }
  throw PreceptException('Unrecognised type');
}

/// [validationEnum] is not typesafe.  There does not appear to be an 'isEnum' type check available in Dart
/// Data type is used for file names etc, may not exactly match the real data type
/// as naming of validationEnum is independent of backend
void _validationFunction(
    {required StringBuffer buf,
    required String functionCode,
    required String functionName,
    required String dataType,
    required List<String> exports}) {
  buf.writeln('function $functionName(request, field, param){');
  buf.writeln('  let value=${dataType}Value(request,field);');
  buf.writeln('  if ($functionCode) return;');
  buf.writeln('  throw \'validation\';');
  buf.writeln('}');
  buf.writeln();
  exports.add('  $functionName');
}

_retrieveValue({required StringBuffer buf, required String type}) {
  buf.writeln('function ${type}Value(request, field){');
  if (type == 'integer') {
    buf.writeln('  return parseInt(request.object.get(field));');
  } else {
    buf.writeln('  return request.object.get(field);');
  }
  buf.writeln('}');
  buf.writeln();
}

bool _checkType(Object candidate) {
  switch (candidate.runtimeType) {
    case ValidateInteger:
    case ValidateString:
      return true;
    default:
      return false;
  }
}

//object.save (validation and ACL)

// roles

// CLP
