import 'package:json_diff/json_diff.dart';
import 'package:takkan_medley_orchestrator/schema/medley_schema.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Schema round trip', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      medleySchema2.init(schemaName: 'test');
      final out1 = medleySchema2.toJson();
      final back1 = Schema.fromJson(out1);
      back1.init(schemaName: 'test');
      // when
      final differ = JsonDiffer.fromJson(out1, back1.toJson());
      DiffNode diff = differ.diff();
      // then
      print(diff.added); // => {"e": 11}
      print(diff.removed); // => {"a": 2}
      print(diff.changed); // => {"b": [3, 7]}
      // expect(out1.toString(), back1.toJson());

      final schema1 = medleySchema2;
      final schema2 = back1;

      expect(schema1.name, schema2.name);
      expect(schema1.version, schema2.version);
      expect(schema1.allRoles, schema2.allRoles);
      expect(schema1.defaultRoleDocument, schema2.defaultRoleDocument);
      expect(schema1.defaultUserDocument, schema2.defaultUserDocument);
      expect(schema1.documentCount, schema2.documentCount);
      // expect(schema1.documents, schema2.documents);

      expect(medleySchema2.toJson(), back1.toJson());
      // expect(medleySchema2, back1, reason: 'should be Equatable');
    });
  });
}
