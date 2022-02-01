import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('StringValidator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('validate', () {
      // given
      PScript script = PScript(
        name: 'A script',
        version: PVersion(number: 0),
        schema: PSchema(
          name: 'test',
          version: PVersion(number: 0),
        ),
      );
      // script.init();

      final PString field = PString(
        validations: [
          VString.longerThan(3),
          VString.shorterThan(6),
        ],
      );

      // when

      // then

      expect(
          field.doValidate('ab', script), ['must be more than 3 characters']);
      expect(field.doValidate('abcdedfg', script),
          ['must be less than 6 characters']);
      expect(field.doValidate('abcd', script), []);
    });

    test('shorterThan', () {
      // given
      final val1 = VString.shorterThan(5);
      // when

      // then

      expect(VString.ref(val1).messageKey, StringValidation.shorterThan);
      expect(VString.ref(val1).javaScript, 'value.length < threshold');
      expect(VString.ref(val1).params, {'threshold': 5});
    });

    test('longerThan', () {
      // given
      final val1 = VString.longerThan(5);
      // when

      // then

      expect(VString.ref(val1).messageKey, StringValidation.longerThan);
      expect(VString.ref(val1).javaScript, 'value.length > threshold');
      expect(VString.ref(val1).params, {'threshold': 5});
    });

    /// The set is used to detect duplicates declared in refs
    test('refs', () {
      // given
      Set s = Set();

      // when
      VString.refs().forEach((element) {
        s.add(element.name);
      });
      // then

      expect(VString.refs().length, StringValidation.values.length);
      expect(s.length, VString.refs().length);
    });
  });
}
