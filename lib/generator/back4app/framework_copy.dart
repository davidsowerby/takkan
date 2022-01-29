import 'dart:io';

import 'package:dio/dio.dart' as dio;

/// Copies framework Cloud Code to [outputDirectory], in accordance with the structure
/// defined by the [CLI](https://www.back4app.com/docs/platform/parse-cli).
///
/// A 'cloud' directory is automatically appended to [outputDirectory] unless
/// the final segment of the path is already 'cloud'.
///
/// https://gitlab.com/api/v4/projects/32200275/repository/files/code%2Fframework.js/raw?ref=master
Future<Directory> copyFrameworkCode({
  required Directory outputDirectory,
}) async {
  final lastSegment = outputDirectory.path.split('/').last;
  final output = (lastSegment == 'cloud') ? outputDirectory : Directory('${outputDirectory.path}/cloud');
  final filesToCopy = const [
    'code/main.js',
    'code/frameworkFunctions.js',
    'code/frameworkTriggers.js',
  ];
  final List<Future<File>> outputs = List.empty(growable: true);
  for (String f in filesToCopy) {
    final f2 = f.replaceAll('/', '%2F');
    final dio.Response response = await dio.Dio().get(
        'https://gitlab.com/api/v4/projects/32200275/repository/files/$f2/raw?ref=master');
    final File outputFile = File('${output.path}/$f');
    await outputFile.create(recursive: true);
    final future = outputFile.writeAsString(response.data);
    outputs.add(future);
  }
  Future.wait(outputs);
  return outputDirectory;
}
