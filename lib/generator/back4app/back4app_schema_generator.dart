import 'dart:convert';
import 'dart:io';

import 'package:takkan_server_code_generator/generator/diff.dart';
import 'package:takkan_server_code_generator/generator/format.dart';
import 'package:takkan_server_code_generator/generator/generated_file.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/validation/result.dart';
import 'package:takkan_script/validation/validate.dart';

abstract class BackendSchemaGenerator {}

/// Generates Back4App Cloud Code files
/// [mainJs] and [files] are only valid after [generateCode] has been invoked
class Back4AppSchemaGenerator implements BackendSchemaGenerator {
  final Map<String, GeneratedFile> files = {};

  /// Writes all the [files] to [outputDirectory].  This is usually the directory you use for
  /// uploading cloud code to Back4App.  Call [generateCode] first.
  Future<List<File>> writeFiles(Directory outputDirectory) async {
    final List<Future<File>> futures = List.empty(growable: true);
    for (GeneratedFile gf in files.values) {
      futures.add(gf.writeFile(outputDirectory));
    }
    return Future.wait(futures);
  }

  /// [schemas] must contain an list of Schema ordered by descending version number,
  /// that is, newest first.
  generateCode({required List<Schema> schemas}) {
    final schema = schemas.first;
    final diff = generateDiff(
      current: schema,
      previous: (schemas.length > 1) ? schemas[1] : null,
    );
    _generateAppJs(schema, diff);
    _generateValidationFiles();
    _generateBeforeSaveJs();

    generateMainJs(schema: schema);
    generatePackageJson();
  }

  _generateAppJs(Schema schema, SchemaDiff diff) {
    final currentVersion = schema.version.number;
    final deprecatedVersions = schema.version.deprecated.join(',');
    outln(
        'const versionStatus = {\'current\': $currentVersion, \'deprecated\': [$deprecatedVersions]};');
    outln();
    outn('const userCLP = ');
    outJson(map: publicCLP);
    outln();
    outn('const roleCLP = ');
    outJson(map: roleDefaultCLP);

    for (int version in schema.version.activeVersions) {
      _version(version, diff);
    }
    _appSchemas(schema.version.activeVersions);
    _moduleExports();
    final file = JavaScriptFile(
        fileName: 'app.js', dataTypeLabel: '', lines: bufContentAsLines);
    files[file.fileName] = file;
  }

  _appSchemas(List<int> allVersions) {
    outln();
    outt('async function appSchemas(version) ');
    openBlock();
    outln();
    outt('switch (version) ');
    openBlock();
    for (int version in allVersions) {
      outlt('case $version:');
      tabLevel++;
      outlt('return version$version();');
      tabLevel--;
    }
    outlt('default :');
    tabLevel++;
    outlt('throw \'Invalid version\'');
    tabLevel--;
    closeBlock();
    closeBlock();
  }

  _version(int versionNumber, SchemaDiff diff) {
    outln();
    outt('async function version$versionNumber() ');
    openBlock();
    outln();
    outlt('// Create Classes');

    for (Document doc in diff.create.values) {
      _createClass(doc);
    }

    outln();
    outlt('// Update Classes');
    for (DocumentDiff doc in diff.update.values) {
      _updateClass(doc);
    }
    outln();
    outlt('// Delete Classes');
    for (Document doc in diff.delete.values) {
      _deleteClass(doc);
    }
    outln();
    closeBlock();
  }

  _createClass(Document doc) {
    outln();
    outlt('const schema = new Parse.Schema(\'${doc.name}\');');
    for (String s in doc.fields.keys) {
      final Field f = doc.fields[s]!;
      outlt('schema.add${_modelType(f)}(\'$s\', ${_fieldAttribs(f)});');
    }
    outlt('await schema.save(null, {useMasterKey: true});');
  }

  _updateClass(DocumentDiff diff) {}

  _deleteClass(Document doc) {}

  GeneratedFile get stringValidation =>
      _generatedFileProperty('string_validation.js');

  GeneratedFile get integerValidation =>
      _generatedFileProperty('integer_validation.js');

  GeneratedFile get mainJs => _generatedFileProperty('main.js');

  GeneratedFile get beforeSaveJs => _generatedFileProperty('before_save.js');

  GeneratedFile get frameworkJs => _generatedFileProperty('framework.js');

  JSONFile get packageJson =>
      _generatedFileProperty('package.json') as JSONFile;

  GeneratedFile get appJs => _generatedFileProperty('app.js');

  GeneratedFile _generatedFileProperty(String fileName) {
    final f = files[fileName];
    if (f != null) {
      return f;
    }
    throw Exception('GeneratedFile for $fileName not found');
  }

  _modelType(Field source) {
    switch (source.runtimeType) {
      case FInteger:
        return 'Number';
      case FString:
        return 'String';
    }
  }

  String _fieldAttribs(Field source) {
    final req = '{required: ${source.required.toString()}';
    return (source.defaultValue == null)
        ? '$req}'
        : '$req, defaultValue: ${source.defaultValue}}';
  }

  generatePackageJson() {
    final JSONFile file = JSONFile(fileName: 'package.json', json: {
      "dependencies": {"validator": "13.6.0"}
    });
    files[file.fileName] = file;
  }

  /// This relies on validation files being generated first
  generateMainJs({required Schema schema}) {
    resetBuf();
    _requiredFile(appJs);
    _requiredFile(beforeSaveJs);
    _requiredFile(frameworkJs);

    // for (GeneratedFile gf in files.values) {
    //   final jf = gf as JavaScriptFile;
    //   outlt("var validate${jf.dataTypeLabel} = require('./${jf.fileName}');");
    // }
    // outln();
    // for (Document doc in schema.documents.values) {
    //   outt('Parse.Cloud.beforeSave("${doc.name}", (request) => ');
    //   openBlock();
    //   outlt(
    //       'const requestedSchemaVersion = parseInt(request.params.schema_version); ');
    //   outt('switch (requestedSchemaVersion) ');
    //   openBlock();
    //   for (int c in schema.version.activeVersions) {
    //     outt('case $c: ');
    //     openBlock();
    //     doc.fields.forEach((fieldName, field) {
    //       for (V v in field.validations) {
    //         final ref = validationRef(v);
    //         final paramsList = ref.params.values.join(',');
    //         final dataTypeLabel = field.runtimeType.toString().substring(1);
    //         outlt(
    //             'validate$dataTypeLabel.${ref.name}(request,\'$fieldName\',$paramsList);');
    //       }
    //     });
    //     outlt("'return 'success';'");
    //     closeBlock();
    //     outt('default: ');
    //     openBlock();
    //     outln("throw 'invalid use ${schema.version.number}';");
    //     closeBlock();
    //     closeBlock();
    //     closeBlock(terminator: ');');
    //   }
    //
    //   // closeBlock(terminator: ');');
    //   closeBlock();
    // }

    final mainJs = JavaScriptFile(
      fileName: 'main.js',
      dataTypeLabel: '',
      lines: bufContentAsLines,
    );
    files[mainJs.fileName] = mainJs;
  }

  _generateValidationFiles() {
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

  _generateBeforeSaveJs() {
    resetBuf();
    _requiredFile(integerValidation);
    _requiredFile(stringValidation);
    JavaScriptFile beforeSave = JavaScriptFile(
      fileName: 'before_save.js',
      lines: bufContentAsLines,
    );
    files[beforeSave.fileName] = beforeSave;
  }

  void _moduleExports() {
    outln();
    outt('module.exports = ');
    openBlock();
    outlt('userCLP: userCLP,');
    outlt('roleCLP: roleCLP,');
    outlt('appSchemas: appSchemas,');
    outlt('versionStatus: versionStatus');
    closeBlock(terminator: ';');
  }
}

_requiredFile(GeneratedFile gf) {
  outlt('require(\'./${gf.fileName}\');');
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
  resetBuf();
  final List<String> exports = List.empty(growable: true);

  for (var element in requireModules) {
    outlt("var val = require('$element');");
  }

  if (requireModules.isNotEmpty) {
    outln();
  }

  int c = 0;
  for (var element in cases) {
    final String functionName = element.name;
    _validationFunction(
      dataTypeLabel: dataTypeLabel.toLowerCase(),
      functionCode: element.javaScript,
      exports: exports,
      functionName: functionName,
      params: element.params.keys.toList(),
    );
    c++;
  }

  _retrieveValue(dataTypeLabel: dataTypeLabel);

  /// extract exports;
  outt('module.exports = ');
  openBlock();
  for (String export in exports) {
    final comma = export == (exports.last) ? '' : ',';
    outlt('$export$comma');
  }
  closeBlock(terminator: ';');
  return JavaScriptFile(
      dataTypeLabel: dataTypeLabel,
      fileName: '${dataTypeLabel.toLowerCase()}_validation.js',
      lines: bufContentAsLines);
}

/// [validationEnum] is not typesafe.  There does not appear to be an 'isEnum' type check available in Dart
/// Data type is used for file names etc, may not exactly match the real data type
/// as naming of validationEnum is independent of backend
void _validationFunction(
    {required String functionCode,
    required String functionName,
    required String dataTypeLabel,
    required List<String> params,
    required List<String> exports}) {
  final p = params.join(',');
  outt('function $functionName(request, field, $p) ');
  openBlock();
  outlt('let value = ${dataTypeLabel}Value(request, field);');
  outlt('if ($functionCode) return;');
  outlt('throw \'validation\';');
  closeBlock();
  outln();
  exports.add(functionName);
}

_retrieveValue({required String dataTypeLabel}) {
  outt('function ${dataTypeLabel.toLowerCase()}Value(request, field) ');
  openBlock();
  if (dataTypeLabel.toLowerCase() == 'integer') {
    outlt('return parseInt(request.object.get(field));');
  } else {
    outlt('return request.object.get(field);');
  }
  closeBlock();
  outln();
}

//object.save (validation and ACL)

// roles

// CLP

/// This is what Back4App sets User CLP to initially
const publicCLP = {
  "find": {"*": true},
  "count": {"*": true},
  "get": {"*": true},
  "create": {"*": true},
  "update": {"*": true},
  "delete": {"*": true},
  "addField": {"*": true},
  "protectedFields": {"*": []}
};

/// This is what Back4App sets Role CLP to initially
const roleDefaultCLP = {
  "find": {"*": true, "requiresAuthentication": true},
  "count": {"*": true, "requiresAuthentication": true},
  "get": {"*": true, "requiresAuthentication": true},
  "create": {"requiresAuthentication": true},
  "update": {},
  "delete": {},
  "addField": {},
  "protectedFields": {"*": []}
};
