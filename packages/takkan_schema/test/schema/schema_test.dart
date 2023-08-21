import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:test/test.dart';

import '../fixtures.dart';

void main() {
  group('schema', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    group('SchemaSet', () {
      test('init passes name to base version', () {
        // given
        const schemaName = 'test';
        final SchemaSet schemaSet = SchemaSet(
            baseVersion: Schema(
              version: const Version(versionIndex: 0),
            ),
            diffs: [],
            schemaName: schemaName);
        // when
        schemaSet.init();
        // then
        expect(schemaSet.baseVersion.name, schemaName);
      });
      test('schemaVersions includes baseVersion', () {
        // given
        const schemaName = 'test';
        final SchemaSet schemaSet = SchemaSet(
            baseVersion: Schema(
              version: const Version(versionIndex: 0),
            ),
            diffs: [],
            schemaName: schemaName);
        // when
        schemaSet.init();

        // then
        expect(schemaSet.schemaVersions.values, contains(schemaSet.baseVersion));

      });
      test('version from deltas', () {
        // given
        const schemaName = 'test';
        final SchemaSet schemaSet0 = SchemaSet(
          baseVersion: Schema(
              version: const Version(
                versionIndex: 0,
                label: '0.0.1',
              ),
              documents: {
                'Person': Document(fields: {
                  'name': Field<String>(
                      constraints: [V.string.lengthGreaterThan(3)]),
                  'age': Field<int>(
                    constraints: [V.int.greaterThan(0)],
                    defaultValue: 10,
                    required: true,
                  ),
                }),
              }),
          diffs: [
            SchemaDiff(
              version: const Version(versionIndex: 1, label: '0.1.0'),
              addDocuments: {
                'Club': Document(fields: {
                  'name': Field<String>(
                      constraints: [V.string.lengthGreaterThan(4)]),
                  'rank': Field<int>(
                    required: false,
                    defaultValue: 5,
                  ),
                })
              },
              amendDocuments: {
                'Person': DocumentDiff(addFields: {
                  'familyName': Field<String>(),
                }, amendFields: {
                  'age': FieldDiff<int>(removeDefaultValue: true),
                })
              },
            )
          ],
          schemaName: schemaName,
        );
        final expected = SchemaSet(
            baseVersion: Schema(
                version: const Version(versionIndex: 1, label: '0.1.0'),
                documents: {
                  'Person': Document(fields: {
                    'name': Field<String>(
                        constraints: [V.string.lengthGreaterThan(3)]),
                    'age': Field<int>(
                      constraints: [V.int.greaterThan(0)],
                      required: true,
                    ),
                    'familyName': Field<String>(),
                  }),
                  'Club': Document(fields: {
                    'name': Field<String>(
                        constraints: [V.string.lengthGreaterThan(4)]),
                    'rank': Field<int>(
                      required: false,
                      defaultValue: 5,
                    ),
                  }),
                }),
            diffs: [],
            schemaName: 'test');
        // when
        schemaSet0.init();
        expected.init();
        final actual = schemaSet0.schemaVersion(1);
        // then
        expect(actual, expected.baseVersion);
      });
      group('version management', () {
        late SchemaSet schemaSet;

        setUp(() {
          schemaSet = SchemaSet(
            baseVersion: Schema(
              version: const Version(versionIndex: 1),
            ),
            schemaName: 'test',
          );
          schemaSet.init();
        });

        test('addVersion adds a new version', () {
          // when
          schemaSet
              .addVersion(SchemaDiff(version: const Version(versionIndex: 2)));

          // then
          expect(schemaSet.schemaVersions.length, 2);
          expect(schemaSet.validSchemaVersions.keys, contains(2));
        });

        test('exclude a version', () {
          // given
          schemaSet
              .addVersion(SchemaDiff(version: const Version(versionIndex: 2)));

          // when
          schemaSet.changeVersionStatus(2, VersionStatus.excluded);

          // then
          expect(schemaSet.schemaVersions.length, 2);
          expect(schemaSet.validSchemaVersions.containsKey(2), false);
        });

        test('exclude rejected by base version', () {
          // given
          schemaSet
              .addVersion(SchemaDiff(version: const Version(versionIndex: 2)));
          // when, then
          expect(()=>schemaSet.changeVersionStatus(1, VersionStatus.excluded),throwsTakkanException);
        });

        test('release deprecates current release ', () {
          // given
          schemaSet
              .addVersion(SchemaDiff(version: const Version(versionIndex: 2)));
          // when 2 versions released
          schemaSet.changeVersionStatus(1, VersionStatus.released);
          schemaSet.changeVersionStatus(2, VersionStatus.released);
          // then
          expect(schemaSet.schemaVersion(1).status,VersionStatus.deprecated);
          expect(schemaSet.schemaVersion(2).status,VersionStatus.released);
        });

        test('expire a version', () {
          schemaSet.addVersion(SchemaDiff(
              version: const Version(
                  versionIndex: 2, status: VersionStatus.released)));

          schemaSet.changeVersionStatus(2, VersionStatus.expired);

          expect(schemaSet.schemaVersion(2).status, VersionStatus.expired);
        });

        test('move to alpha', () {
          schemaSet.addVersion(SchemaDiff(
              version: const Version(
                  versionIndex: 2)));

          schemaSet.changeVersionStatus(2, VersionStatus.alpha);

          expect(schemaSet.schemaVersion(2).status, VersionStatus.alpha);
        });

        test('deprecate a version', () {
          schemaSet.addVersion(SchemaDiff(
              version: const Version(
                  versionIndex: 2, status: VersionStatus.released)));

          schemaSet.changeVersionStatus(2, VersionStatus.deprecated);

          expect(schemaSet.schemaVersion(2).status, VersionStatus.deprecated);
        });
      });
    });
  });
}
