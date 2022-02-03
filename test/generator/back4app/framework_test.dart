import 'dart:convert';

import 'package:test/test.dart';

import '../../fixture.dart';

void main() {
  group('Framework code', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('resetInstance & initPrecept', () async {
      // given

      // when
      var response = await execute(function: 'resetInstance');

      // then
      var result = response.data['result']['status'];
      print("Result of reset: ${response.data['result']}");
      expect(result, 'success');
      // when
      response = await execute(function: 'initPrecept');

      // then
      result = response.data['result'];
      expect(result, 'success');
    }, timeout: Timeout(Duration(minutes: 3)));
    test('getSchema', () async {
      // given

      // when
      var response =
          await execute(function: 'getSchema', params: {'className': '_Role'});

      // then
      var result = response.data['result'];
      expect(result['className'], '_Role');

      final clp = result['classLevelPermissions'];
      print(json.encode(clp));
      print('');
    }, timeout: Timeout(Duration(minutes: 3)));
  });
  test('applyServerSchema', () async {
    // given

    // when
    var response =
        await execute(function: 'applyServerSchema', params: {'version': 0});
    // then
    var result = response.data['result'];
    expect(result, 'success');
  });

}
