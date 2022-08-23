import 'package:takkan_schema/schema/schema.dart';

import '../generated_file.dart';
import 'function_file.dart';

/// A Javascript file specifically used to define a cloud function API.
///
/// Implementation is delegated to a [FunctionJavaScriptFile] for example:
///
/// ``` javascript
/// Parse.Cloud.define("doSomething", async (request) => {
///    doSomething(request);
// });
/// ```
///
/// where the 'doSomething' function is declared in a [FunctionJavaScriptFile]
class APIJavaScriptFile extends JavaScriptFile {
  APIJavaScriptFile({required this.documentClassName});

  final Map<String, FunctionJavaScriptFile> functionFiles = {};
  final String documentClassName;

  @override
  String get fileName => 'api.js';

  @override
  void specify({required List<Schema> schemaVersions}) {
    elements.add(RequireStatement(
      requiredModule: './functions.js',
      assignment: 'f',
    ));
    elements.add(BlankStatement());
    final documentVersions = schemaVersions
        .where((schemaVersion) =>
            schemaVersion.documents.containsKey(documentClassName))
        .map((schemaVersion) => DocumentVersion(
            schemaVersion.document(documentClassName), schemaVersion.version));

    final queryNames = documentVersions
        .expand((documentVersion) => documentVersion.document.queries.keys)
        .toSet()
        .toList();

    queryNames.sort();

    elements.addAll(queryNames.map(
      (queryName) => APIDeclaration(
        documentClassName: documentClassName,
        functionName: queryName,
      ),
    ));
  }
}

class APIDeclaration extends Block {
  APIDeclaration({
    required this.documentClassName,
    required this.functionName,
    super.blankLinesAfter = 1,
  }) : super();

  final String documentClassName;
  final String functionName;

  @override
  String get opening =>
      "Parse.Cloud.define('$functionName', async (request) => {";

  @override
  String get closing => '});';

  @override
  void createContent() {
    content.add(Statement('return f.$functionName(request)'));
  }
}
