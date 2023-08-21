import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:test/test.dart';

void main() {
  group('Field Selector', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('directly specified', () {
      // given
      final Document schema = Document(fields: {'c': Field<String>()});
      const selector = FieldSelector(fields: ['a', 'b']);
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['a', 'b']);
    });

    test('all fields true, direct fields ignored', () {
      // given
      final Document schema =
          Document(fields: {'c': Field<String>(), 'd': Field<String>()});
      const selector = FieldSelector(
        fields: ['a', 'b'],
        allFields: true,
      );
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['c', 'd', 'objectId']);
    });
    test('all fields except excluded', () {
      // given
      final Document schema =
          Document(fields: {'c': Field<String>(), 'd': Field<String>()});
      const selector = FieldSelector(
        excludeFields: ['c'],
        allFields: true,
      );
      // when
      final selection = selector.selection(schema);
      // then

      expect(selection, ['d', 'objectId']);
    });
    test('all fields plus meta, except excluded', () {
      // given
      final Document schema =
          Document(fields: {'c': Field<String>(), 'd': Field<String>()});
      const selector = FieldSelector(
        excludeFields: ['c'],
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
      final Document schema =
          Document(fields: {'c': Field<String>(), 'd': Field<String>()});
      const selector = FieldSelector(
        excludeFields: ['c', 'updatedAt'],
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
