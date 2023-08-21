import 'package:mocktail/mocktail.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:test/test.dart';

import '../../fixtures.dart';

void main() {
  group('Document', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    group('Document', () {
      test('hasValidation', () {
        // given
        final field1 = MockField();
        when(() => field1.hasValidation).thenReturn(false);
        final fieldWithValidation = MockField();
        when(() => fieldWithValidation.hasValidation).thenReturn(true);
        final doc1 = Document(fields: const {});
        final doc2 = Document(fields: {'a': fieldWithValidation});
        final doc3 = Document(fields: {'a': field1});
        // when

        // then
        expect(doc1.hasValidation, isFalse);
        expect(doc2.hasValidation, isTrue);
        expect(doc3.hasValidation, isFalse);
      });
      test('Document has default permissions', () {
        // given
        final Document document = Document(fields: const {});
        // when

        // then
        expect(document.requiresAuthentication(AccessMethod.create), true);
        expect(document.requiresAuthentication(AccessMethod.find), true);
        expect(document.requiresAuthentication(AccessMethod.update), true);
        expect(document.requiresAuthentication(AccessMethod.delete), true);
        expect(document.requiresAuthentication(AccessMethod.get), true);
        expect(document.requiresAuthentication(AccessMethod.count), true);
        expect(document.requiresAuthentication(AccessMethod.addField), true);
      });
    });
    group('DocumentDiff', () {
      test('diff makes no changes', () {
        // given
        final field1 = MockField();
        final doc = Document(fields: {'a': field1});
        const diff = DocumentDiff();
        // when
        final result = diff.applyTo(doc);
        // then
        expect(result, equals(doc));
      });
      test('diff changes fields', () {
        // given
        final fieldA = MockField();
        final fieldB = MockField();
        final fieldB1 = MockField();
        final fieldC = MockField();
        final fieldDiff= MockFieldDiff();
        when(() => fieldDiff.applyTo(fieldB)).thenReturn(fieldB1);
        final doc = Document(fields: {'a': fieldA, 'b': fieldB});
        final diff = DocumentDiff(
          addFields: {'c': fieldC},
          amendFields: {'b': fieldDiff},
          removeFields: ['a'],
        );
        // when
        final Document result = diff.applyTo(doc);
        // then
        expect(result.fields.containsValue(fieldA), isFalse);
        expect(result.fields.containsValue(fieldB), isFalse);
        expect(result.fields.containsValue(fieldB1), isTrue);
        expect(result.fields.containsValue(fieldC), isTrue);
      });

    });
  });
}
