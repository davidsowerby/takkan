import 'package:takkan_script/schema/schema.dart';

import '../generated_file.dart';

class MainJavaScriptFile extends JavaScriptFile {
  final List<String> requires = List.empty(growable: true);

  @override
  String get fileName => 'main.js';

  @override
  void specify({required List<Schema> schemaVersions}) {
    elements.add(RequireStatement(requiredModule: './framework.js'));
    elements.addAll(
      requires.map(
        (e) => RequireStatement(requiredModule: e),
      ),
    );
  }
}
