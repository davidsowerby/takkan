import 'package:takkan_script/data/provider/document_id.dart';
import 'package:test/test.dart';

void main() {
  group('DocumentId', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('isEmpty', () {
      // given
      final docId = DocumentId.empty();
      const docId1 = DocumentId(objectId: '', documentClass: '');
      // when

      // then

      expect(docId.isEmpty, true);
      expect(docId1.isEmpty, true);
    });
    test('not empty', () {
      // given
      const docId = DocumentId(objectId: '', documentClass: 'X');
      // when

      // then

      expect(docId.isEmpty, isFalse);
    });    test('compare', () {
          // given
    const docId1=DocumentId(documentClass: 'A', objectId: 'B');
    const docId2=DocumentId(documentClass: 'A', objectId: 'B');
          // when

          // then

          expect(docId1, docId2);
          expect(docId1.hashCode, docId2.hashCode);
        });
  });
}
