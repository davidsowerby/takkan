import 'package:takkan_schema/schema/schema.dart';

import '../generated_file.dart';
import 'api_file.dart';

// For use when a backend instance is used to store Takkan Script and Schema versions
class StoreJavaScriptFile extends JavaScriptFile {
  @override
  String get fileName => 'store.js';

  @override
  void specify({required List<Schema> schemaVersions}) {
    elements.add(APIDeclaration(
        documentClassName: Schema.documentClassName,
        functionName: Schema.supportedVersions));
  }
}
