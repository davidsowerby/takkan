import 'package:takkan_schema/schema/schema.dart';

import '../generated_file.dart';

/// Defines the triggers (beforeSave, afterSave etc) for a specific [documentClassName].
///
/// beforeSave implementation contains field validation
///
/// Naming convention is  {className-triggers.js} where className is lower cased
/// first character of the Back4App class name.
class TriggerJavaScriptFile extends JavaScriptFile {
  TriggerJavaScriptFile({required this.documentClassName});

  final String documentClassName;

  @override
  void specify({required List<Schema> schemaVersions}) {
    elements.addAll([
      RequireStatement(
        assignment: 'b4a',
        requiredModule: '../../b4a_schema.js',
        blankLinesAfter: 1,
      ),
      BeforeSaveTrigger(
        documentClassName: documentClassName,
        schemaVersions: schemaVersions,
      ),
    ]);
  }

  @override
  String get fileName => 'triggers.js';
}

abstract class Trigger extends Block {
  Trigger({super.commentsBefore});
}

/// Takes all schema versions that contain this [documentClassName] and constructs
/// validation rules.
///
/// **NOTE** The capture of current schema version takes a default value from
/// b4_schema.js.  Without this, updating data through the Back4App Dashboard
/// will not work
class BeforeSaveTrigger extends Trigger {
  BeforeSaveTrigger({
    required this.schemaVersions,
    required this.documentClassName,
    super.commentsBefore = const [
      'Default schema_version is provided, otherwise data cannot be updated from the Back4App Dashboard',
      'To validate what might be a partial update, we check original if present'
    ],
  });

  List<Schema> schemaVersions;
  final String documentClassName;

  @override
  String get opening =>
      "Parse.Cloud.beforeSave('$documentClassName', (request) => {";

  @override
  void createContent() {
    content.addAll([
      ExtractSchemaVersionFromRequest(),
      BlankStatement(),
      Switch(
        param: 'schema_version',
        cases: [
          ...schemaVersions
              .where((schemaVersion) =>
                  schemaVersion.documents.containsKey(documentClassName))
              .map((schemaVersion) => DocumentVersion(
                    schemaVersion.document(documentClassName),
                    schemaVersion.version,
                  ))
              .map(
                (docVersion) => Case(
                    docVersion.version.number,
                    [
                      ...docVersion.document.fields.values
                          .where((field) => field.hasValidation)
                          .map((field) => ValidationElement(field: field))
                    ],
                    blankLinesAfter: 1),
              )
        ],
        defaultCase: DefaultCase(
          [Statement("throw 'Invalid version requested';")],
        ),
      ),
    ]);
  }

  @override
  String get closing => '});';
}
