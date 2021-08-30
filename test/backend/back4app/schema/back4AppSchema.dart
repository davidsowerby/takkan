import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/schemaConverter.dart';

void main() {
  group('Back4App Schema model', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    group('Back4AppSchema', () {
      // given
      File f = File('reference.json');
      final ref = f.readAsStringSync();

      test('structure', () {
        // given
        final schema = Back4AppSchema.fromJson(json.decode(ref));

        // then
        // expect(schema.role.name, '_Role');
        // expect(schema.role.fields['ACL']?.name, 'ACL');
        // expect(schema.role.fields['ACL']?.type, 'ACL');
        // final wb = schema.getClass('WigglyBeast');
        // expect(wb, isNotNull);
        // expect(wb.name, 'WigglyBeast');
        // expect(wb.classLevelPermissions, isNotNull);
        // final clp = wb.classLevelPermissions;
        // expect(clp.find, {
        //   '*': true,
        //   'role:editor': true,
        //   'role:wiggly': true,
        //   'requiresAuthentication': true
        // });
      });
    });
  });
}
