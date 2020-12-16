import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_script/script/script.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchensink.html#static-page)
void main() {
  group('Static Page (kitchen-sink-00)', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    testWidgets('All ', (WidgetTester tester) async {
      // given
      partLibrary.init();
      final script = PScript(isStatic: IsStatic.yes);
      script.init();
      // when
      final testTree = Directionality();
      await tester.pumpWidget(testTree);
      final widgetList = tester.allWidgets.toList();
      // then

      expect(widgetList, isNotEmpty);
    });
  });
}