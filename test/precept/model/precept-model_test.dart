import 'package:precept/app/model.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:test/test.dart';

/// Not much to be done here, the model uses BuiltValue
void main() {
  group('Model', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('JSON round trip', () {
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
