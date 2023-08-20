import 'package:mocktail/mocktail.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_client/part/text/text_particle.dart';
import 'package:test/test.dart';

import '../helper/mock.dart';

void main() {
  late ParticleInterpolator interpolator;
  group('ParticleInterpolator', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('Static data, user not authenticated ', () {
      // given
      interpolator = ParticleInterpolator(
          partConfig: MockPartConfig(),
          dataContext: MockDataContextWithParams());
      when(() => interpolator.partConfig.isStatic).thenReturn(true);
      when(() => interpolator.partConfig.staticData)
          .thenReturn('Static data for {#user.name}');
      when(() => interpolator.dataContext.dataProvider.userIsNotAuthenticated)
          .thenReturn(true);

      // when
      final actual = interpolator.interpolate();
      // then
      expect(actual, 'Static data for ?');
    });

    test('Static data, user is authenticated ', () {
      // given
      TakkanUser user = TakkanUser.fromJson({'name': 'Wiggly'});
      interpolator = ParticleInterpolator(
          partConfig: MockPartConfig(),
          dataContext: MockDataContextWithParams());
      when(() => interpolator.partConfig.isStatic).thenReturn(true);
      when(() => interpolator.partConfig.staticData)
          .thenReturn('Static data for {#user.name}');
      when(() => interpolator.dataContext.dataProvider.userIsNotAuthenticated)
          .thenReturn(false);
      when(() => interpolator.dataContext.dataProvider.user).thenReturn(user);

      // when
      final actual = interpolator.interpolate();
      // then
      expect(actual, 'Static data for Wiggly');
    });

    test('Dynamic data only', () {
      // given
      interpolator = ParticleInterpolator(
          connector: MockModelConnector(),
          partConfig: MockPartConfig(),
          dataContext: MockDataContextWithParams());
      when(() => interpolator.partConfig.isStatic).thenReturn(false);
      when(() => interpolator.partConfig.staticData).thenReturn(null);
      when(() => interpolator.connector?.readFromModel()).thenReturn('5');

      // when
      final actual = interpolator.interpolate();
      // then
      expect(actual, '5');
    });

    test('Dynamic data embedded in static data', () {
      // given
      interpolator = ParticleInterpolator(
          connector: MockModelConnector(),
          partConfig: MockPartConfig(),
          dataContext: MockDataContextWithParams());
      when(() => interpolator.partConfig.isStatic).thenReturn(false);
      when(() => interpolator.partConfig.staticData)
          .thenReturn('Your score is: {}');
      when(() => interpolator.connector?.readFromModel()).thenReturn('5');

      // when
      final actual = interpolator.interpolate();
      // then
      expect(actual, 'Your score is: 5');
    });
  });
}

String getAString(String key) {
  return 'A Result';
}
