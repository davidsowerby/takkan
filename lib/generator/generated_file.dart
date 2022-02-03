import 'dart:convert';

import 'dart:io';

abstract class GeneratedFile {
  final String fileName;
  final List<String> lines;

  GeneratedFile({required this.fileName, required this.lines});


  String get content => lines.join('\n');

  Future<File> writeFile(Directory outputDirectory) async {
    final File outputFile = File('${outputDirectory.path}/$fileName');
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await outputFile.create();
    return outputFile.writeAsString(content, flush: true);
  }
}

/// [dataTypeLabel] is only used for validation files.  Data type names may not
/// be identical between client and backend, and are therefore declared explicitly
class JavaScriptFile extends GeneratedFile {

  final String dataTypeLabel;

  JavaScriptFile(
      {required String fileName,
        this.dataTypeLabel='',
        required List<String> lines})
      : super(fileName: fileName, lines : lines);
}

class JSONFile extends GeneratedFile {
  final Map<String, dynamic> json;

  JSONFile({required String fileName, required this.json})
      : super(fileName: fileName, lines: []);

  @override
  String get content => jsonEncode(json);

}

