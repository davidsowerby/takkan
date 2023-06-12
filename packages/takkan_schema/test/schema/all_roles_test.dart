import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/schema/schema.dart';

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
          fields: const {},
        ),
        'doc2': Document(
          permissions: const Permissions(
            readRoles: ['doc1-read', 'doc2-read'],
            updateRoles: ['admin'],
          ),
          fields: const {},
        ),
      });

      schema.init();
      final expected = ['doc1-get', 'doc1-read', 'admin', 'doc2-read'];
      // when

      // then
      // final walkLog = WalkClasses();
      // script.walk([walkLog]);
      // ignore: avoid_print
      print(schema.allRoles);
      expect(schema.allRoles, containsAll(expected));
      expect(schema.allRoles.length, expected.length);
      //
      // expect(schema.allRoles, containsAll(expected));
      // expect(schema.allRoles.length, expected.length);
    });
  });
}
