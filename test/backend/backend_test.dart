import 'package:precept_backend/backend/backend.dart';
import 'package:precept_script/script/backend.dart';
import 'package:test/test.dart';

import 'backendLibrary_test.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('connection cycle', () async {
      // given
      List<BackendConnectionState> states=List();
      final Backend backend = TestBackend();
      backend.addListener((connectionState) => states.add(connectionState));
      // expect
      expect(backend.connectionState, BackendConnectionState.idle);
      // when
      await backend.connect();
      // then
      expect(backend.connectionState, BackendConnectionState.connected);
      expect(states[0],BackendConnectionState.connecting);
      expect(states[1],BackendConnectionState.connected);

      // when
      backend.fail();

      // then
      expect(backend.connectionState, BackendConnectionState.failed);

      // when
      backend.reset();

      // then
      expect(backend.connectionState, BackendConnectionState.idle);
      expect(states[0],BackendConnectionState.connecting);
      expect(states[1],BackendConnectionState.connected);
      expect(states[2],BackendConnectionState.failed);
      expect(states[3],BackendConnectionState.idle);
    });

  });
}
