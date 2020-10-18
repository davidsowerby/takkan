import 'package:precept/precept/model/precept-signin.dart';
import 'package:test/test.dart';

void main() {
  group('Precept signin', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given

      // when
      final signin = PreceptSignIn((b) => b
        ..backend = Backend.back4app
        ..brand = "brandy");
      // then
      print(signin.toJson());
      expect(1, 0);
    });
  });
}
