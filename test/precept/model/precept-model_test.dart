import 'package:precept/app/model.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:test/test.dart';

void main() {
  group('Unit test', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () {
      // given

      // when
      Precept precept = testModel();
      print(precept.toJson());
      Precept precept1 = Precept.fromJson(precept.toJson());
      // then

      expect(precept, precept1);
    });
  });
}
