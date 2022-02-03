
import 'package:precept_server_code_generator/generator/diff.dart';
import 'package:test/test.dart';
import 'package:precept_script/example/medley_schema.dart';

void main() {
  group('Diff', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('nothing to 0', () {
      // given
      final previous = null;
      final current = medleySchema[0];
      current.init();
      // when
      final result = generateDiff(previous: previous, current: current);
      // then

      expect(result.create.length, 1);
      expect(result.delete, isEmpty);
      expect(result.update,isEmpty);
      expect(result.create.keys, containsAll(['Person']));


    });
    test('0 to 1', () {
      // given
      final previous = medleySchema[0];
      final current = medleySchema[1];
      previous.init();
      current.init();
      // when
      final result = generateDiff(previous: previous, current: current);
      // then

      expect(result.create, isEmpty);
      expect(result.delete, isEmpty);
      expect(result.update.length,1);
      expect(result.update.keys, containsAll(['Person']));

      DocumentDiff updated=result.update['Person']!;
      expect(updated.name,'Person');
      expect(updated.create.length,1);
      expect(updated.create.keys,containsAll(['first name']));
      expect(updated.delete,isEmpty);
      expect(updated.update.length,3);
      expect(updated.update.keys,containsAll(['age','height','siblings']));
      expect(updated.update['age']!.toJson(),medleySchema1.documents['Person']!.fields['age']!.toJson(),reason: 'make sure the complete and correct field has been identified');

    });
  });
}
