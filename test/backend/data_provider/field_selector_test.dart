import 'package:precept_script/data/select/field_selector.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('Field Selector', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('directly specified', () {
      // given
      PDocument schema = PDocument(fields: {'c': PString()});
      final selector = FieldSelector(fields: const ['a', 'b']);
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['a', 'b']);
    });

    test('all fields true, direct fields ignored', () {
      // given
      PDocument schema = PDocument(fields: {'c': PString(), 'd': PString()});
      final selector = FieldSelector(
        fields: const ['a', 'b'],
        allFields: true,
      );
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['c', 'd', 'objectId']);
    });
    test('all fields except excluded', () {
      // given
      PDocument schema = PDocument(fields: {'c': PString(), 'd': PString()});
      final selector = FieldSelector(
        excludeFields: const ['c'],
        allFields: true,
      );
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['d', 'objectId']);
    });
    test('all fields plus meta, except excluded', () {
      // given
      PDocument schema = PDocument(fields: {'c': PString(), 'd': PString()});
      final selector = FieldSelector(
        excludeFields: const ['c'],
        includeMetaFields: true,
        allFields: true,
      );
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['d', 'objectId', 'createdAt', 'updatedAt']);
    });
    test('all fields plus meta, except excluded one meta excluded', () {
      // given
      PDocument schema = PDocument(fields: {'c': PString(), 'd': PString()});
      final selector = FieldSelector(
        excludeFields: const ['c', 'updatedAt'],
        includeMetaFields: true,
        allFields: true,
      );
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['d', 'objectId', 'createdAt']);
    });
  });
}
