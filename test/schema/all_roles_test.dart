import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('all roles', () {
    test('combined', () {
      // given
      final schema =
          Schema(name: '', version: const Version(number: 0), documents: {
        'doc1': Document(
          permissions: const Permissions(
            getRoles: ['doc1-get'],
            readRoles: ['doc1-read', 'admin'],
          ),
          fields: {},
        ),
            'doc2': Document(
              permissions: const Permissions(
            readRoles: ['doc1-read', 'doc2-read'],
            updateRoles: ['admin'],
          ),
          fields: {},
        ),
      });
      final script = Script(
          name: 'test',
          version: const Version(number: 0),
          schema: schema,
          dataProvider: DataProvider(
              instanceConfig: const AppInstance(instance: 'x', group: 'x')));
      script.init();
      final expected = ['doc1-get', 'doc1-read', 'admin', 'doc2-read'];
      // when

      // then
      // final walkLog = WalkClasses();
      // script.walk([walkLog]);
      print(script.allRoles);
      expect(script.allRoles, containsAll(expected));
      expect(script.allRoles.length, expected.length);
      //
      // expect(schema.allRoles, containsAll(expected));
      // expect(schema.allRoles.length, expected.length);
    });
  });
}
