import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

import '../script/walk_test.dart';

void main() {
  group('all roles', () {
    // test('empty', () {
    //   // given
    //   final script = kitchenSinkScript;
    //   script.init();
    //   // when
    //
    //   // then
    //
    //   expect(script.allRoles.length, 0);
    // });
    test('combined', () {
      // given
      final schema =
          PSchema(name: '', version: PVersion(number: 0), documents: {
        'doc1': PDocument(
          permissions: PPermissions(
            getRoles: ['doc1-get'],
            readRoles: ['doc1-read', 'admin'],
          ),
          fields: {},
        ),
        'doc2': PDocument(
          permissions: PPermissions(
            readRoles: ['doc1-read', 'doc2-read'],
            updateRoles: ['admin'],
          ),
          fields: {},
        ),
      });
      final script = PScript(
          name: 'test',
          version: PVersion(number: 0),
          schema: schema,
          dataProvider: PDataProvider(
              schema: schema,
              providerName: 'x',
              sessionTokenKey: 'x',
              configSource: PConfigSource(instance: 'x', segment: 'x')));

      final expected = ['doc1-get', 'doc1-read', 'admin', 'doc2-read'];
      // when

      // then
      final walkLog = WalkClasses();
      script.walk([walkLog]);
      print(script.allRoles);
      expect(script.allRoles, containsAll(expected));
      expect(script.allRoles.length, expected.length);

      expect(schema.allRoles, containsAll(expected));
      expect(schema.allRoles.length, expected.length);
    });
  });
}
