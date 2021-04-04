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
      final log=WalkLog();
      // when
      script.walk([log]);
      // then

      expect(log.calls,['PScript','PRestDataProvider','PRoute','PPage','PPart','PPanel', 'PPanelHeading','PPart']);
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
