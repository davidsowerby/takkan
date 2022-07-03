import 'package:takkan_medley_script/schema/medley_schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:takkan_server_code_generator/generator/diff.dart';
import 'package:test/test.dart';

void main() {
  group('Diff', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('nothing to 0', () {
      // given
      final current = medleySchema0;
      final Script script = Script(
          name: 'test', schema: current, version: const Version(number: 0));
      script.init();
      // when
      final result = generateDiff2(current: current);
      // then

      expect(result.create.length, 1);
      expect(result.delete, isEmpty);
      expect(result.update, isEmpty);
      expect(result.create.keys, containsAll(['Person']));
    });
    test('0 to 1', () {
      // given
      final previousSchema = medleySchema0;
      final currentSchema = medleySchema1;
      final Script previousScript = Script(
          name: 'previous',
          schema: previousSchema,
          version: const Version(number: 0));
      final Script currentScript = Script(
          name: 'current',
          schema: currentSchema,
          version: const Version(number: 0));
      previousScript.init();
      currentScript.init();
      // when
      final result =
          generateDiff2(previous: previousSchema, current: currentSchema);
      // then

      expect(result.create.length, 1);
      expect(result.delete, isEmpty);
      expect(result.update.length, 1);
      expect(result.update.keys, containsAll(['Person']));

      final DocumentDiff updated = result.update['Person']!;
      expect(updated.name, 'Person');
      expect(updated.create.length, 1);
      expect(updated.create.keys, containsAll(['lastName']));
      expect(updated.delete, isEmpty);
      expect(updated.update.length, 4);
      expect(updated.update.keys,
          containsAll(['age', 'height', 'siblings', 'firstName']));
      expect(updated.update['age']!.current.toJson(),
          medleySchema1.documents['Person']!.fields['age']!.toJson(),
          reason:
              'make sure the complete and correct field has been identified');
    });
  }, skip: false);
}
