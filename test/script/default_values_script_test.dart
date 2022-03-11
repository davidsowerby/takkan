import 'package:precept_medley_script/medley/medley_script.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/query_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:test/test.dart';

/// Round tripping some times fails if default values are not set consistent through the inheritance tree.
///
/// It seems almost random, so it may vary depending on how the process runs at any given time.
void main() {
  group('round trip components', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('PNavButtonSet', () {
      // given

      // when
      PNavButtonSet a = PNavButtonSet(buttons: {});
      PNavButtonSet b = PNavButtonSet.fromJson(a.toJson());
      // then
      expect(a.height, 60.0);
      expect(a.toJson(), b.toJson());
    });
    test('PQueryView', () {
      // given

      // when
      PQueryView a = PQueryView();
      PQueryView b = PQueryView.fromJson(a.toJson());
      // then
      // expect(a.height, 60.0);
      expect(a.toJson(), b.toJson());
    });
    test('caption from PText', () {
      // given
      medleyScript0.init();
      // when
      PText pText = medleyScript0.routes['/']?.children[0] as PText;
      // then

      expect(pText.caption, isNull);
    });
  });
}
