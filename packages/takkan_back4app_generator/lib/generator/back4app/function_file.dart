import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/query/query.dart';
import 'package:takkan_schema/schema/schema.dart';

import '../generated_file.dart';

/// Defines a cloud function file for a specific [documentClass].
///
/// The full code generation comprises the API call, and a delegate to do the work:
///
/// **Example:**
///
/// A 'Person' class might generate a function to return all adults:
///
/// **API**
///
/// ```javascript
/// Parse.Cloud.define("personAdult", async (request) => {
///   return personAdult();
/// });
/// ```
///
/// **Delegate**
///
/// ```javascript
/// async function personAdult(){
///    const query = new Parse.Query("Person");
///     query.greaterThan("age", 17);
///     return await query.find();
/// }
/// ```
///
/// The cloud code is generated from instances of [Condition], held in a [Query],
/// in turn held in a [Document].
///
/// API entries are also created [APIJavaScriptFile]
///
class FunctionJavaScriptFile extends JavaScriptFile {
  FunctionJavaScriptFile({required this.documentClassName});

  final String documentClassName;

  @override
  String get fileName => 'functions.js';

  @override
  void specify({
    required List<Schema> schemaVersions,
  }) {
    final moduleExport = ModuleExport();
    elements.add(
      RequireStatement(
        assignment: 'b4a',
        requiredModule: '../../b4a_schema.js',
        blankLinesAfter: 1,
      ),
    );
    // Get all versions of the document identified by documentClassName
    final documentVersions = schemaVersions
        .where((schemaVersion) =>
            schemaVersion.documents.containsKey(documentClassName))
        .map((schemaVersion) => DocumentVersion(
            schemaVersion.document(documentClassName), schemaVersion.version));

    final Map<String, List<QueryVersion>> functions = {};
    for (final DocumentVersion dv in documentVersions) {
      dv.document.queries.forEach((key, value) {
        final List<QueryVersion> versions =
            functions.putIfAbsent(key, () => List.empty(growable: true));
        versions.add(QueryVersion(
          query: value,
          versionNumber: dv.version.versionIndex,
        ));
      });
    }
    functions.forEach((key, value) {
      elements.add(
        QueryFunction(
          functionName: key,
          versions: value,
          documentClassName: documentClassName,
        ),
      );
    });
    functions.forEach((key, value) {
      moduleExport.addExport(key);
    });
    elements.add(DelegateFunction(
        functionName: 'checkExactlyOne',
        parameters: ['results'],
        isAsync: false,
        elements: [
          IfBlock(
              condition: 'results.length === 1',
              ifContent: [Statement('return results[0]')],
              elseContent: []),
          IfBlock(
              condition: 'results.length < 1',
              ifContent: [Statement("throw 'Not Found'")],
              elseContent: []),
          IfBlock(
              condition: 'results.length > 1',
              ifContent: [Statement("throw 'Multiple results'")],
              elseContent: []),
        ]));
    elements.add(moduleExport);
  }
}

class DelegateFunction extends Block {
  DelegateFunction({
    this.isAsync = true,
    this.parameters = const ['request'],
    required this.functionName,
    required this.elements,
    super.blankLinesAfter = 1,
  });

  final bool isAsync;
  final String functionName;
  final List<String> parameters;
  final List<JavaScriptElement> elements;

  @override
  String get opening =>
      '${async}function $functionName(${parameters.join(', ')}) {';

  @override
  void createContent() {
    content.addAll(elements);
  }

  String get async => isAsync ? 'async ' : '';
}

class QueryFunction extends Block {
  QueryFunction(
      {required this.functionName,
      required this.versions,
      required this.documentClassName,
      super.blankLinesAfter = 1});

  final String functionName;
  final String documentClassName;
  final List<QueryVersion> versions;

  @override
  String get opening => 'async function $functionName(request) {';

  @override
  void createContent() {
    versions.sort((a, b) => a.versionNumber.compareTo(b.versionNumber));

    final List<Case> cases = versions
        .map(
          (e) => Case(
              e.versionNumber,
              [
                QueryFunctionVersion(
                    number: e.versionNumber,
                    queryVersion: e,
                    documentClassName: documentClassName)
              ],
              useBreak: false),
        )
        .toList();
    content.addAll([
      ExtractSchemaVersionFromRequest(),
      BlankStatement(),
      Switch(
        param: 'schema_version',
        cases: cases,
        defaultCase: DefaultCase(
          [Statement("throw 'Invalid version requested';")],
        ),
      ),
    ]);
  }
}

class QueryFunctionVersion extends StatementSet {
  QueryFunctionVersion({
    required this.number,
    required this.queryVersion,
    required this.documentClassName,
  });

  final int number;
  final QueryVersion queryVersion;
  final String documentClassName;

  @override
  void createContent() {
    final conditions =
        queryVersion.query.conditions.map((e) => Statement(e.cloudCode));

    content.addAll([
      Statement("const query = new Parse.Query('$documentClassName');"),
      ...conditions,
      Statement('const results = await query.find();'),
      if (queryVersion.query.returnSingle)
        Statement('return checkExactlyOne(results)')
      else
        Statement('return results'),
    ]);
  }
}

class QueryVersion {
  QueryVersion({required this.versionNumber, required this.query});

  final Query query;
  final int versionNumber;
}
