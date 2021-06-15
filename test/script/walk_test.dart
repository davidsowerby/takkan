import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/example/kitchenSink.dart';

void main() {
  group('Walking', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given
      final script = kitchenSinkScript;
      final log = WalkLog();
      // when
      script.walk([log]);
      // then

      // StringBuffer buf=StringBuffer();
      // log.calls.forEach((element) {
      //   buf.write('\'$element\',');
      // });
      // print(buf.toString());
      expect(log.calls, [
        'PScript',
        'PNoDataProvider',
        'PSchemaSource',
        'PPage',
        'PPanel',
        'PText',
        'PText',
        'PNavButton',
        'PPage',
        'PNavButtonSet',
        'PPage',
        'PEmailSignIn',
        'PPage',
        'PNavButtonSet',
        'PPage',
        'PGQuery',
        'PPanel',
        'PQueryView',
        'PPage',
        'PPanel',
        'PPQuery',
        'PPanelHeading',
        'PText',
        'PText',
        'PPage',
        'PPage',
        'PPanel',
        'PPanelHeading',
        'PText',
        'PText'
      ]);
    });
  });
}

class WalkLog implements ScriptVisitor {
  final List<String> calls = List.empty(growable: true);

  WalkLog();

  @override
  step(PreceptItem entry) {
    calls.add(entry.runtimeType.toString());
  }
}
