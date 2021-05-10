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
      final PPermissions permissions = PPermissions(requiresAuthentication: [RequiresAuth.all]);
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




  });
}
