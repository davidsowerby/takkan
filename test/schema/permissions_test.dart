import 'package:takkan_script/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Permissions', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('default no permissions required', () {
      // given
      final Permissions permissions = Permissions();
      // when

      // then

      expect(permissions.requiresCreateAuthentication, false);
      expect(permissions.requiresFindAuthentication, false);
      expect(permissions.requiresUpdateAuthentication, false);
      expect(permissions.requiresDeleteAuthentication, false);
      expect(permissions.requiresFindAuthentication, false);
      expect(permissions.requiresGetAuthentication, false);
      expect(permissions.requiresCountAuthentication, false);
      expect(permissions.requiresAddFieldAuthentication, false);
    });

    test('RequiresAuth.all returns correctly', () {
      // given
      final Permissions permissions =
          Permissions(requiresAuthentication: [AccessMethod.all]);
      // when

      // then
      expect(permissions.requiresCreateAuthentication, true);
      expect(permissions.requiresFindAuthentication, true);
      expect(permissions.requiresUpdateAuthentication, true);
      expect(permissions.requiresDeleteAuthentication, true);
      expect(permissions.requiresFindAuthentication, true);
      expect(permissions.requiresGetAuthentication, true);
      expect(permissions.requiresCountAuthentication, true);
      expect(permissions.requiresAddFieldAuthentication, true);

      expect(permissions.allRoles, []);
    });

    test('role set, requiresAuthentication returns true', () {
      // given
      final Permissions permissions = Permissions(
        createRoles: ['boss'],
        readRoles: ['boss'],
        updateRoles: ['boss'],
        deleteRoles: ['boss'],
      );
      // when

      // then

      expect(permissions.requiresCreateAuthentication, true);
      expect(permissions.requiresFindAuthentication, true);
      expect(permissions.requiresUpdateAuthentication, true);
      expect(permissions.requiresDeleteAuthentication, true);
      expect(permissions.requiresFindAuthentication, true);
      expect(permissions.requiresGetAuthentication, true);
      expect(permissions.requiresCountAuthentication, true);
      expect(permissions.requiresAddFieldAuthentication, false);

      expect(permissions.allRoles, ['boss']);
    });

    test('PDocument has default permissions', () {
      // given
      final Document document = Document(fields: const {});
      // when

      // then
      expect(document.requiresCreateAuthentication, false);
      expect(document.requiresFindAuthentication, false);
      expect(document.requiresUpdateAuthentication, false);
      expect(document.requiresDeleteAuthentication, false);
    });

    test('readRoles added to get, find, count', () {
      // given
      final Document document = Document(
          permissions: Permissions(
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

      expect(document.permissions.allRoles,
          containsAll(['reader', 'getter', 'finder', 'counter']));
    });

    test('writeRoles added to create, update, delete', () {
      // given
      final Document document = Document(
          permissions: Permissions(
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
