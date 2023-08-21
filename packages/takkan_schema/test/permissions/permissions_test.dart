import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/document/permissions.dart';
import 'package:test/test.dart';

void main() {
  final basicMethods = AccessMethodExtension.basicMethods;
  final readMethods = AccessMethodExtension.readMethods;
  final writeMethods = AccessMethodExtension.writeMethods;
  group('Permissions', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('default no permissions given', () {
      // given
      final Permissions permissions = Permissions();
      // when

      // then

      expect(permissions.requiresAuthentication(AccessMethod.get), true);
      expect(permissions.isPublic(AccessMethod.get), false);
      expect(permissions.permissions, isEmpty);
    });

    test('all set to authOnly', () {
      // given
      final Permissions permissions = Permissions(permissions: const {
        AccessMethod.all: [authOnly]
      });
      // when

      // then

      for (final method in basicMethods) {
        expect(permissions.permissions[method], [authOnly]);
        expect(permissions.requiresAuthentication(method), true);
        expect(permissions.isPublic(method), false);
        expect(permissions.hasPermission(method, true, {'admin'}), true);
        expect(permissions.hasPermission(method, true, {'author'}), true);
      }
    });
    test('read set to authOnly', () {
      // given
      final Permissions permissions = Permissions(permissions: const {
        AccessMethod.read: [authOnly]
      });
      // when

      // then

      for (final method in readMethods) {
        expect(permissions.permissions[method], [authOnly]);
        expect(permissions.requiresAuthentication(method), true);
        expect(permissions.isPublic(method), false);
        expect(permissions.hasPermission(method, true, {'admin'}), true);
        expect(permissions.hasPermission(method, true, {'author'}), true);
      }
      for (final method in writeMethods) {
        expect(permissions.permissions[method], null);
        expect(permissions.requiresAuthentication(method), true);
        expect(permissions.isPublic(method), false);
        expect(permissions.hasPermission(method, true, {'admin'}), false);
        expect(permissions.hasPermission(method, true, {'author'}), false);
      }
    });
    test('write set to authOnly', () {
      // given
      final Permissions permissions = Permissions(permissions: const {
        AccessMethod.write: [authOnly]
      });
      // when

      // then

      for (final method in readMethods) {
        expect(permissions.permissions[method], null);
        expect(permissions.requiresAuthentication(method), true);
        expect(permissions.isPublic(method), false);
        expect(permissions.hasPermission(method, true, {'admin'}), false);
        expect(permissions.hasPermission(method, true, {'author'}), false);
      }
      for (final method in writeMethods) {
        expect(permissions.permissions[method], [authOnly]);
        expect(permissions.requiresAuthentication(method), true);
        expect(permissions.isPublic(method), false);
        expect(permissions.hasPermission(method, true, {'admin'}), true);
        expect(permissions.hasPermission(method, true, {'author'}), true);
      }
    });

    test('role set, requiresAuthentication returns true', () {
      // given
      final Permissions permissions = Permissions(permissions: const {
        AccessMethod.all: ['admin']
      });
      // when

      // then

      for (final method in basicMethods) {
        expect(permissions.permissions[method], ['admin']);
        expect(permissions.requiresAuthentication(method), true);
        expect(permissions.isPublic(method), false);
        expect(permissions.hasPermission(method, true, {'admin'}), true);
        expect(permissions.hasPermission(method, true, {'author'}), false);
      }
    });
  });
  group('PermissionsDiff', () {
    test('adds new roles', () {
      // given
      final Permissions permissions = Permissions(permissions: const {
        AccessMethod.create: ['admin'],
        AccessMethod.get: [authOnly],
      });
      const PermissionsDiff diff = PermissionsDiff(addRoles: {
        AccessMethod.write: ['editor'],
        AccessMethod.find: ['admin'],
      });
      final expected = Permissions(permissions: const {
        AccessMethod.create: ['admin', 'editor'],
        AccessMethod.get: [authOnly],
        AccessMethod.delete: ['editor'],
        AccessMethod.update: ['editor'],
        AccessMethod.find: ['admin'],
        AccessMethod.addField: ['editor'],
      });
      // when
      final actual = diff.applyTo(permissions);
      // then
      expect(actual.roles(AccessMethod.addField),
          expected.roles(AccessMethod.addField));
      expect(
          actual.roles(AccessMethod.count), expected.roles(AccessMethod.count));
      expect(actual.roles(AccessMethod.create),
          expected.roles(AccessMethod.create));
      expect(actual.roles(AccessMethod.delete),
          expected.roles(AccessMethod.delete));
      expect(
          actual.roles(AccessMethod.find), expected.roles(AccessMethod.find));
      expect(actual.roles(AccessMethod.get), expected.roles(AccessMethod.get));
      expect(actual.roles(AccessMethod.update),
          expected.roles(AccessMethod.update));
    });
    test('remove roles', () {
      // given
      final base = Permissions(permissions: const {
        AccessMethod.create: ['admin', 'editor'],
        AccessMethod.get: [authOnly],
        AccessMethod.delete: ['editor'],
        AccessMethod.update: ['editor'],
        AccessMethod.find: ['admin'],
        AccessMethod.addField: ['editor'],
      });
      const diff = PermissionsDiff(removeRoles: {
        AccessMethod.delete: ['editor'],
        AccessMethod.create: ['editor'],
      }, addRoles: {
        AccessMethod.delete: ['admin']
      });
      final expected = Permissions(permissions: const {
        AccessMethod.create: ['admin'],
        AccessMethod.get: [authOnly],
        AccessMethod.delete: ['admin'],
        AccessMethod.update: ['editor'],
        AccessMethod.find: ['admin'],
        AccessMethod.addField: ['editor'],
      });
      // when

      // then
    });
  });
}
