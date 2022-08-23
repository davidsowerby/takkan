import 'dart:io';

import 'package:takkan_back4app_generator/generator/back4app/schema_generator/cloud_generator.dart';
import 'package:takkan_back4app_generator/generator/back4app/server_code_structure.dart';
import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
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

    final Back4AppCloudGenerator generator = Back4AppCloudGenerator();
    final Directory systemTemp = Directory.systemTemp;
    final Directory temp = await systemTemp.createTemp('codegen');
    final ServerCodeStructure structure =
        ServerCodeStructure(outputDir: temp,);
    generator.generateCode(schemaVersions: schemaVersions);
    // when
    // await structure.writeFilesExcludingSchemaAndFramework();

    // then

    final rootFileList = temp.listSync();
    final rootFileListNames = rootFileList.map((e) => e.path);
    final rootPath = temp.path;
    expect(rootFileListNames.length, 5);
    expect(
        rootFileListNames,
        containsAll([
          '$rootPath/b4a_schema.js',
          '$rootPath/classes',
          '$rootPath/main.js',
          '$rootPath/framework.js',
          '$rootPath/store.js',
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
