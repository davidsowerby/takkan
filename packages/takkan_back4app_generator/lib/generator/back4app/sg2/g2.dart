import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/schema.dart';

/// [schemas] must have run init before calling this function
String generateValidation(List<Schema> schemas) {
  final importStatements = <String>{};
  importStatements.add("const b4a = require('../../b4a_schema.js');");
  final bodies = <String>[];

  final allDocumentNames = extractAllDocumentNames(schemas);

  for (final documentName in allDocumentNames) {
    bodies.add(beforeSaveBody(
      schemas: schemas,
      documentName: documentName,
      importStatements: importStatements,
    ));
  }

  final imports = importStatements.toList();
  imports.sort();
  imports.add('');
  final buffer = StringBuffer(imports.map((s) => '$s\n').join());
  buffer.write(bodies.join('\n'));
  return buffer.toString();
}

Set<String> extractAllDocumentNames(List<Schema> schemas) {
  final names = <String>{};
  for (final schema in schemas) {
    names.addAll(schema.documents.keys);
  }
  return names;
}

String beforeSaveBody({
  required List<Schema> schemas,
  required String documentName,
  required Set<String> importStatements,
}) {
  final body = StringBuffer();

  body.writeln(
      '// Default schema_version is provided, otherwise data cannot be updated from the Back4App Dashboard');
  body.writeln(
      '// To validate what might be a partial update, we check original if present');

  body.writeln("Parse.Cloud.beforeSave('$documentName', (request) => {");

  body.writeln('  if (!request.params.schema_version) {');
  body.writeln("    throw 'schema_version is required';");
  body.writeln('  }');

  body.writeln();

  body.writeln(
      '  const requestedSchemaVersion = parseInt(request.params.schema_version);');

  body.writeln();

  body.writeln('  try {');
  body.writeln('    switch (requestedSchemaVersion) {');

  for (final schema in schemas) {
    body.writeln('      case ${schema.version.versionIndex}: {');

    for (final doc in schema.documents.entries) {
      for (final Field<dynamic> field in doc.value.fields.values) {
        if (field.hasValidation) {
          importStatements.add(field.cloudImportStatement);
        }
        for (final Condition<dynamic> condition in field.conditions) {
          body.writeln(
              '        ${field.cloudImportName}.${condition.cloudCode}');
        }
      }

      body.writeln('        request.success();');
      body.writeln('      }');
    }
  }

  body.writeln('      default: {');
  final validSchemaVersions = schemas.map((s) => s.version.versionIndex).join(',');
  body.writeln(
      "        throw 'invalid schema_version. Use one of: $validSchemaVersions';");
  body.writeln('      }');
  body.writeln('    }');
  body.writeln('  } catch (error) {');
  body.writeln('    response.status(400);');
  body.writeln("    response.error('Bad Request');");
  body.writeln('  }');
  body.write('});');
  return body.toString();
}
