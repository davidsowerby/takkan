import 'dart:io';

import 'package:takkan_medley_script/schema/medley_schema.dart';
import 'package:takkan_server_code_generator/generator/back4app/schema_generator/schema_generator.dart';
import 'package:test/test.dart';

import '../../compare_file.dart';

void main() {
  group('Generator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});
  });
  test('output structure', () async {
    // given

    final SchemaGenerator2 generator = SchemaGenerator2();
    final Directory systemTemp = Directory.systemTemp;
    final Directory temp = await systemTemp.createTemp('codegen');
    final ServerCodeStructure structure =
        ServerCodeStructure(outputDir: temp, jsFiles: generator.files);
    generator.generateCode(schemaVersions: medleySchema);
    // when
    await structure.writeFiles();

    // then

    final rootFileList = temp.listSync();
    final rootFileListNames = rootFileList.map((e) => e.path);
    final rootPath = temp.path;
    expect(rootFileListNames.length, 4);
    expect(
        rootFileListNames,
        containsAll([
          '$rootPath/b4a_schema.js',
          '$rootPath/classes',
          '$rootPath/main.js',
          '$rootPath/framework.js',
        ]));

    final classesPath = '$rootPath/classes';
    final classesList = Directory(classesPath).listSync();
    final classesListNames = classesList.map((e) => e.path);
    expect(classesListNames.length, 2,
        reason: 'User and Role have been temporarily excluded from generation');
    expect(
        classesListNames,
        containsAll([
          '$classesPath/Issue',
          '$classesPath/Person',
          // '$classesPath/User',
          // '$classesPath/Role',
        ]),
        reason: 'User and Role have been temporarily excluded from generation');

    final personPath = '$classesPath/Person';
    final personList = Directory(personPath).listSync();
    final personListNames = personList.map((e) => e.path);
    expect(personListNames.length, 3);
    expect(
        personListNames,
        containsAll([
          '$personPath/functions.js',
          '$personPath/triggers.js',
          '$personPath/api.js',
        ]));
    final issuePath = '$classesPath/Issue';
    final issueList = Directory(issuePath).listSync();
    final issueListNames = issueList.map((e) => e.path);
    expect(
        issueListNames,
        containsAll([
          '$issuePath/functions.js',
          '$issuePath/triggers.js',
          '$issuePath/api.js',
        ]));

    // then check main.js here as it is constructed during generation
    final mainJsActual = File('${temp.path}/main.js');
    expect(mainJsActual.existsSync(), isTrue);
    final File mainJsRef =
        File('test/generator/back4app/main_file/main_ref.txt');
    final List<String> expected = mainJsRef.readAsLinesSync();
    final List<String> actual = mainJsActual.readAsLinesSync();
    expect(compareLines(expected: expected, actual: actual).length, 0);
  });
}
