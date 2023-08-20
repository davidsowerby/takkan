import 'dart:async';

import 'package:takkan_client/data/streamed_output.dart';
import 'package:test/test.dart';

void main() {
  group('StreamedOutput', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () async {
      // given
      final List<Map<String, dynamic>> events = List.empty(growable: true);
      final StreamedOutput output = StreamedOutput(getEditHost: () => null);
      // when
      output.stream.listen((event) {
        events.add(event);
      });
      output.update(data: {'a': 'initial'});
      await Future.delayed(Duration(milliseconds: 200));
      output.update(data: {'a': '1'});
      output.update(data: {'a': '2'});
      await Future.delayed(Duration(milliseconds: 200));
      output.update(data: {'a': '3'});
      output.update(data: {'a': '4'});
      output.update(data: {'a': '5'});
      // then
      await Future.delayed(Duration(seconds: 1));
      expect(events.length, 6);
      expect(events[5], {'a': '5'});
      expect(events[4], {'a': '4'});
      expect(events[3], {'a': '3'});
      expect(events[2], {'a': '2'});
      expect(events[1], {'a': '1'});
      expect(events[0], {'a': 'initial'});

      expect(output.data, {'a': '5'},
          reason: 'Data should reflect the last event');
      expect(output.rootBinding.read(), {'a': '5'},
          reason: 'Root binding has been attached');
    });
  });
}
