import 'dart:io';

import 'package:characters/characters.dart';
import 'package:takkan_script/data/object/geo.dart';
import 'package:takkan_script/data/object/json_object.dart';
import 'package:takkan_script/data/object/pointer.dart';
import 'package:takkan_script/data/object/relation.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';

import '../diff.dart';
import '../generated_file.dart';
import 'function_file.dart';

/// A Javascript file providing a versioned Back4App schema builder, generated
/// from the Takkan [Schema] versions.
///
/// It uses [SchemaDiff] to identify changes
class B4ASchemaJavaScriptFile extends JavaScriptFile {
  B4ASchemaJavaScriptFile();

  /// The current version is taken to be the highest version number in [schemaVersions]
  @override
  void specify({
    required List<Schema> schemaVersions,
  }) {
    final List<int> numbers =
        schemaVersions.map((e) => e.version.number).toList();
    numbers.sort();
    final current = numbers.last;

    final deprecatedNumbers = List.from(numbers);
    deprecatedNumbers.removeLast();
    final deprecated = deprecatedNumbers.join(', ');
    final moduleExport = ModuleExport();
    elements.addAll([
      Statement(
        'var deprecatedSchemaVersions = [$deprecated];',
      ),
      Statement(
        'var schemaVersion = $current',
      ),
      Statement(
        "const versionStatus = {'current': schemaVersion, 'deprecated': deprecatedSchemaVersions};",
        blankLinesAfter: 1,
      ),
    ]);
    elements.add(DelegateFunction(functionName: 'applySchema', elements: [
      Statement(
        "const selectedVersion = parseInt(request.get('selectedVersion'))",
      ),
      Statement(
        'schemaVersion = selectedVersion',
        blankLinesAfter: 1,
      ),
      Switch(
        param: 'selectedVersion',
        cases: numbers
            .map((versionNumber) => Case(versionNumber,
                [Statement('return version$versionNumber(request)')],
                useBreak: false))
            .toList(),
        defaultCase: DefaultCase([Statement("throw 'Invalid version'")]),
      ),
    ]));
    moduleExport.addExport('applySchema');
    moduleExport.addExport('schemaVersion');
    moduleExport.addExport('versionStatus');

    final List<SchemaDiff> diffs = _schemaDiffs(schemaVersions);
    for (final SchemaDiff diff in diffs) {
      final version = diff.current.version.number;
      final List<Document> createDocuments = List.from(diff.create.values);
      createDocuments.sort((a, b) => a.name.compareTo(b.name));
      final List<DocumentDiff> updateDocumentDiffs =
          List.from(diff.update.values);

      /// We only want to process field additions or deletions for the schema
      /// Field updates are handled by validation code
      updateDocumentDiffs.removeWhere((element) => element.fieldUpdatesOnly);
      updateDocumentDiffs.sort((a, b) => a.name.compareTo(b.name));
      final List<Document> deleteDocuments = List.from(diff.delete.values);
      deleteDocuments.sort((a, b) => a.name.compareTo(b.name));
      // TODO Temporarily remove User and Role https://gitlab.com/takkan/takkan_design/-/issues/36
      createDocuments.removeWhere(
          (document) => document.name == 'User' || document.name == 'Role');
      elements.add(DelegateFunction(
        functionName: 'version$version',
        elements: [
          BlankStatement(),
          Comment(['Create Classes'], blankLinesAfter: 1),
          ...createDocuments
              .expand((document) => _createDocumentSchema(document, version)),
          Comment(['Update Classes'], blankLinesAfter: 1),
          ...updateDocumentDiffs
              .expand((document) => _updateDocumentSchema(document, version)),
          Comment(['Delete Classes'], blankLinesAfter: 1),
          ...deleteDocuments
              .expand((document) => _deleteDocumentSchema(document)),
          Statement("return 'schema version $version applied'"),
        ],
      ));
      final List<Document> docs = List.from(diff.current.documents.values);
      docs.sort((a, b) => a.name.compareTo(b.name));
      // TODO see https://gitlab.com/takkan/takkan_design/-/issues/34
      docs.removeWhere(
          (element) => element.name == 'User' || element.name == 'Role');
      for (final Document document in docs) {
        elements.add(
          AssignStatement(
              variableName: _clpVariableName(document, version),
              value: CLPObject(
                permissions: document.permissions,
              )),
        );
      }
    }
    elements.add(moduleExport);
  }

  List<JavaScriptElement> _createDocumentSchema(
      Document document, int version) {
    final String schemaVariable = '${decapitaliseName(document)}Schema';
    final clpVariableName = _clpVariableName(document, version);
    return [
      Statement(
          "const $schemaVariable = new Parse.Schema('${document.name}').get()"),
      ..._addSchemaFields(document),
      Statement('$schemaVariable.setCLP($clpVariableName)'),
      Statement('await $schemaVariable.save(null, {useMasterKey: true})'),
      BlankStatement(),
    ];
  }

  /// The [DocumentDiff.update] fields are not used here.  Back4App does not support
  /// changing the data type, and the rest of the field definition is handled through
  /// validation code.  This method therefore only adds and deletes fields
  ///
  /// Field names are sorted for ease of reading and testing
  List<JavaScriptElement> _updateDocumentSchema(
      DocumentDiff documentDiff, int version) {
    final document = documentDiff.current;
    final String schemaVariable = '${decapitaliseName(document)}Schema';
    final getSchemaStatements = [
      Statement(
          "const $schemaVariable = new Parse.Schema('${document.name}').get()"),
    ];

    /// Add fields from diff.create
    final createFields = List<Field<dynamic>>.from(documentDiff.create.values);
    createFields.sort((a, b) => a.name.compareTo(b.name));
    final createStatements = createFields.map((field) => Statement(
        "$schemaVariable.add${_schemaDataTypeMap(field)}('${field.name}')"));

    /// Delete fields from diff.delete
    final deleteFields = List<Field<dynamic>>.from(documentDiff.delete.values);
    deleteFields.sort((a, b) => a.name.compareTo(b.name));
    final deleteStatements = deleteFields.map((field) => Statement(
        "$schemaVariable.delete${_schemaDataTypeMap(field)}('${field.name}')"));

    final clpVariableName = _clpVariableName(document, version);
    final clpStatement = Statement('$schemaVariable.setCLP($clpVariableName)');

    /// Save it
    final saveStatement =
        Statement('await $schemaVariable.update(null, {useMasterKey: true})');

    return [
      ...getSchemaStatements,
      ...createStatements,
      ...deleteStatements,
      clpStatement,
      saveStatement,
      BlankStatement(),
    ];
  }

  String _clpVariableName(Document document, int version) {
    final d = _decapitalise(document.name);
    return '${d}CLP$version';
  }

  @override
  String get fileName => 'b4a_schema.js';

  /// Create diffs for each version increment, starting from nothing (null) if the
  /// current version is 0
  ///
  /// Sort into ascending version number order first to ensure the order is correct
  List<SchemaDiff> _schemaDiffs(List<Schema> schemaVersions) {
    final List<Schema> sortedVersions = List<Schema>.from(schemaVersions);
    sortedVersions.sort((a, b) => a.version.number.compareTo(b.version.number));

    /// If the first version we are passed is at number 0, we need a 'nothing'
    /// before that, so we use an empty schema
    if (sortedVersions[0].version.number == 0) {
      final emptyScript = EmptyScript();
      emptyScript.init();
      sortedVersions.insert(0, emptyScript.schema);
    }
    final List<SchemaDiff> diffs = List.empty(growable: true);

    while (sortedVersions.length >= 2) {
      diffs.add(
          SchemaDiff(previous: sortedVersions[0], current: sortedVersions[1]));
      sortedVersions.removeAt(0);
    }

    return diffs;
  }
}

String _decapitalise(String string) {
  final Characters chars = Characters(string);
  final d = chars.characterAt(0).toLowerCase() + chars.getRange(1);
  return d.toString();
}

String decapitaliseName(Document document) {
  return _decapitalise(document.name);
}

List<JavaScriptElement> _deleteDocumentSchema(Document document) {
  return [];
}

List<JavaScriptElement> _addSchemaFields(Document document) {
  final List<Field<dynamic>> fields = document.fields.values.toList();
  final String schemaVariable = '${decapitaliseName(document)}Schema';
  fields.sort((a, b) => a.name.compareTo(b.name));
  return fields
      .map((field) => Statement(
          "$schemaVariable.add${_schemaDataTypeMap(field)}('${field.name}')"))
      .toList();
}

// TODO: Pointer and relation need to be added with, eg .addPointer('pointerField', '_User')
// and .addRelation('relationField', '_User');
String _schemaDataTypeMap(Field<dynamic> field) {
  switch (field.modelType) {
    case int:
      return 'Number';
    case bool:
      return 'Boolean';
    case String:
      return 'String';
    case DateTime:
      return 'Date';
    case File:
      return 'File';
    case GeoPoint:
      return 'GeoPoint';
    case GeoPolygon:
      return 'Polygon';
    case List:
      return 'Array';
    case JsonObject:
      return 'Object';
    case Pointer:
      return 'Pointer';
    case Relation:
      return 'Relation';
    default:
      throw UnsupportedError(
          'Unsupported data type: ${field.modelType.toString()}');
  }
}

// ignore: must_be_immutable
class EmptyScript extends Script {
  EmptyScript()
      : super(
          name: 'Empty',
          version: const Version(number: 0),
          schema: EmptySchema(),
        );
}

// ignore: must_be_immutable
class EmptySchema extends Schema {
  EmptySchema() : super(name: 'Empty', version: const Version(number: 0));
}
