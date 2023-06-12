import 'package:takkan_back4app_generator/generator/back4app/server_code_structure2.dart';
import 'package:takkan_back4app_generator/generator/generated_file.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      VirtualFolder rootFolder=VirtualFolder(null, '.');
      GeneratedFile gf = TestGeneratedFile('main.js');
      gf.folder=rootFolder;
      // when

      // then

      expect(1, 0);
    });
  });
}

class TestGeneratedFile extends GeneratedFile {
  TestGeneratedFile(this.fileName);

  @override
  final String fileName;
}
