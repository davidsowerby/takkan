import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('Integer Validate', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('greaterThan validation', () {
      // given
      final v1 = VInteger.greaterThan(3);
      // when

      // then
      expect(
          VInteger.validate(v1, 1).patternKey, IntegerValidation.greaterThan);
      expect(VInteger.validate(v1, 1).passed, false);
      expect(VInteger.validate(v1, 1).javaScript, 'value > threshold');
      expect(
          VInteger.validate(v1, 3).patternKey, IntegerValidation.greaterThan);
      expect(VInteger.validate(v1, 3).passed, false);
      expect(
          VInteger.validate(v1, 4).patternKey, IntegerValidation.greaterThan);
      expect(VInteger.validate(v1, 4).passed, true);
    });

    test('lessThan validation', () {
      // given
      final v1 = VInteger.lessThan(3);
      // when

      // then
      expect(VInteger.validate(v1, 1).patternKey, IntegerValidation.lessThan);
      expect(VInteger.validate(v1, 1).passed, true);
      expect(VInteger.validate(v1, 1).javaScript, 'value < threshold');
      expect(VInteger.validate(v1, 3).passed, false);
      expect(VInteger.validate(v1, 4).passed, false);
    });

    test('JSON', () {
      // given
      final v11 = VInteger.greaterThan(3);
      final v21 = VInteger.lessThan(3);
      // when
      final v12 = VInteger.fromJson(v11.toJson());
      final v22 = VInteger.fromJson(v21.toJson());
      // then
      expect(v11, v12);
      expect(v21, v22);
    });

    test('field', () {
      // given
      final PScript script = PScript(
        name: 'test',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
      );
      final field = PInteger(validations: [
        VInteger.greaterThan(5),
        VInteger.lessThan(10),
      ]);
      // when

      // then

      expect(field.doValidation(3, script), ['must be greater than 5']);
      expect(field.doValidation(11, script), ['must be less than 10']);
    });

    /// The set is used to detect duplicates declared in refs
    test('refs', () {
      // given
      Set s = Set();

      // when
      VInteger.refs().forEach((element) {
        s.add(element.name);
      });
      // then

      expect(VInteger.refs().length, IntegerValidation.values.length);
      expect(s.length, VInteger.refs().length);
    });
  });
}
