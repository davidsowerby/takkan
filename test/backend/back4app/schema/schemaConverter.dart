import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/preceptBack4AppConverter.dart';
import 'package:precept_back4app_backend/backend/back4app/schema/schemaConverter.dart';
import 'package:precept_script/schema/field/date.dart';
import 'package:precept_script/schema/field/file.dart';
import 'package:precept_script/schema/field/geoPolygon.dart';
import 'package:precept_script/schema/field/geoPosition.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/list.dart';
import 'package:precept_script/schema/field/object.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/relation.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

void main() {
  group('PSchema to Back4AppSchema conversion', () {
    final PreceptBack4AppSchemaConverter converter =
        PreceptBack4AppSchemaConverter();
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('empty schema', () {
      // given
      PSchema pSchema = PSchema(name: 'sample', documents: {});
      pSchema.init();
      // when
      Back4AppSchema bSchema = converter.convert(pSchema);
      // then

      expect(bSchema.extract(), {});
    });

    test('sample class', () {
      // given
      final String documentName = 'TestDoc';
      PSchema pSchema = PSchema(name: 'sample', documents: {
        documentName: PDocument(
          permissions:
              PPermissions(readRoles: ['reader'], getRoles: ['getter']),
          fields: {
            'aString': PString(),
            'aInteger': PInteger(
              defaultValue: 33,
              required: true,
            ),
            // 'aDouble': PDouble(
            //   defaultValue: 33.33,
            //   permissions:
            //       PPermissions(readRoles: ['reader'], getRoles: ['getter']),
            // ),
          },
        )
      });
      pSchema.init();
      // when
      Back4AppSchema bSchema = converter.convert(pSchema);
      // then

      final extract = bSchema.extract();
      expect(extract, contains(documentName));
      final SchemaClass? schemaClass = extract[documentName];
      expect(schemaClass?.className, documentName);

      String fieldName = 'aString';
      expect(schemaClass?.fields, contains(fieldName));
      expect(schemaClass?.fields[fieldName]?.required, false);
      expect(schemaClass?.fields[fieldName]?.type, 'String');
      expect(schemaClass?.fields[fieldName]?.defaultValue, isNull);

      fieldName = 'aInteger';

      expect(schemaClass?.fields, contains(fieldName));
      expect(schemaClass?.fields[fieldName]?.required, true);
      expect(schemaClass?.fields[fieldName]?.type, 'Number');
      expect(schemaClass?.fields[fieldName]?.defaultValue, 33);
      expect(
        schemaClass?.classLevelPermissions?.find,
        {"requiresAuthentication": true, "role:reader": true},
      );
      expect(
        schemaClass?.classLevelPermissions?.get,
        {
          "requiresAuthentication": true,
          "role:getter": true,
          "role:reader": true
        },
      );
      expect(
        schemaClass?.classLevelPermissions?.count,
        {"requiresAuthentication": true, "role:reader": true},
      );

      // fieldName = 'aDouble';
      //
      // expect(schemaClass?.fields, contains(fieldName));
      // expect(schemaClass?.fields[fieldName]?.required, true);
      // expect(schemaClass?.fields[fieldName]?.type, 'Number');
      // expect(schemaClass?.fields[fieldName]?.defaultValue, 33.33);
      // expect(schemaClass?.classLevelPermissions?.find, ['reader']);
    });

    test('reference model, without indexes', () {
      // given
      File f = File('reference.json');
      final referenceStr = f.readAsStringSync();
      final Map<String, dynamic> fullReference = json.decode(referenceStr);
      final List classes = fullReference['results'];

      final nonUserRoles = classes.where((element) =>
          element['className'] != '_User' && element['className'] != '_Role');
      final Map<String, dynamic> reference = {'results': nonUserRoles.toList()};
      classes.forEach((element) {
        element.remove('indexes');
        final clp = element['classLevelPermissions'];
        clp.remove('protectedFields');

        /// this is a hack to fix the different way in which 'requiresAuthentication' is handled
        /// In Back4App 'requiresAuthentication' may be true or null if a role is specified
        /// In Precept 'requiresAuthentication' is always true when a role is specified
        /// Obviously this will break if the reference is changed
        clp['count']['requiresAuthentication'] = true;
        clp['get']['requiresAuthentication'] = true;
        clp['update']['requiresAuthentication'] = true;
        clp['delete']['requiresAuthentication'] = true;

        /// -------------------------------------------------
        final Map<String, dynamic> fields = element['fields'];
        fields.remove('createdAt');
        fields.remove('updatedAt');
        fields.remove('ACL');
        fields.remove('objectId');
      });

      // when
      PSchema pSchema = PSchema(name: 'Sample', documents: {
        'Sample': PDocument(
            fields: {
              'name': PString(),
              'nameWithDefault': PString(defaultValue: 'aDefaultValue'),
              'nameRequired': PString(required: true),
              'number': PInteger(),
              'date': PDate(),
              'object': PJsonObject(),
              'array': PList(),
              'geoPoint': PGeoPosition(),
              'polygon': PGeoPolygon(),
              'file': PFile(),
              'pointToUser': PPointer(targetClass: '_User'),
              'relationToUser': PRelation(targetClass: '_User'),
              'extraField': PString(),
            },
            permissions: PPermissions(
              requiresAuthentication: [AccessMethod.addField],
              isPublic: [AccessMethod.get],
              findRoles: ['author', 'editor'],
              deleteRoles: ['author', 'editor'],
              createRoles: ['author', 'editor'],
              countRoles: ['author', 'editor'],
              updateRoles: ['editor'],
              getRoles: ['author', 'editor'],
            ))
      });
      pSchema.init();
      Back4AppSchema bSchema = converter.convert(pSchema);
      // then

      expect(bSchema.toJson(), reference);
    });
  });
}
