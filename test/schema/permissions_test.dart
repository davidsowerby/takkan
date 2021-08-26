import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/schema/schema.dart';

void main() {
  group('Permissions', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('default no permissions required', () {
      // given
      final PPermissions permissions = PPermissions();
      // when

      // then

      expect(permissions.requiresCreateAuthentication, false);
      expect(permissions.requiresReadAuthentication, false);
      expect(permissions.requiresUpdateAuthentication, false);
      expect(permissions.requiresDeleteAuthentication, false);
    });

    test('RequiresAuth.all returns correctly', () {
      // given
      final PPermissions permissions =
          PPermissions(requiresAuthentication: [RequiresAuth.all]);
      // when

      // then
      expect(permissions.requiresCreateAuthentication, true);
      expect(permissions.requiresReadAuthentication, true);
      expect(permissions.requiresUpdateAuthentication, true);
      expect(permissions.requiresDeleteAuthentication, true);
    });

    test('role set, requiresAuthentication returns true', () {
      // given
      final PPermissions permissions = PPermissions(
        createRoles: ['boss'],
        readRoles: ['boss'],
        updateRoles: ['boss'],
        deleteRoles: ['boss'],
      );
      // when

      // then

      expect(permissions.requiresCreateAuthentication, true);
      expect(permissions.requiresReadAuthentication, true);
      expect(permissions.requiresUpdateAuthentication, true);
      expect(permissions.requiresDeleteAuthentication, true);
    });

    test('PDocument has default permissions', () {
      // given
      final PDocument document = PDocument(fields: const {});
      // when

      // then
      expect(document.requiresCreateAuthentication, false);
      expect(document.requiresReadAuthentication, false);
      expect(document.requiresUpdateAuthentication, false);
      expect(document.requiresDeleteAuthentication, false);
    });

    test('readRoles added to get, find, count', () {
      // given
      final PDocument document = PDocument(
          permissions: PPermissions(
            readRoles: ['reader'],
            getRoles: ['getter'],
            findRoles: ['finder'],
            countRoles: ['counter'],
          ),
          fields: {});
      // when

      // then
      expect(document.permissions.getRoles, ['getter', 'reader']);
      expect(document.permissions.findRoles, ['finder', 'reader']);
      expect(document.permissions.countRoles, ['counter', 'reader']);
    });

    test('writeRoles added to create, update, delete', () {
      // given
      final PDocument document = PDocument(
          permissions: PPermissions(
              writeRoles: ['writer'],
              createRoles: ['creator'],
              updateRoles: ['updater'],
              deleteRoles: ['destroyer']),
          fields: {});
      // when

      // then

      expect(document.permissions.createRoles, ['creator', 'writer']);
      expect(document.permissions.updateRoles, ['updater', 'writer']);
      expect(document.permissions.deleteRoles, ['destroyer', 'writer']);
    });
  });
}
