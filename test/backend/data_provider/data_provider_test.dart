import 'package:mocktail/mocktail.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/delegate.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/graphql_delegate.dart';
import 'package:takkan_script/data/provider/rest_delegate.dart';
import 'package:test/test.dart';

import '../../fixtures/matchers.dart';
import '../../fixtures/mocks.dart';

void main() {
  group('DefaultDataProvider', () {
    AppConfig appConfig = AppConfig(
      data: {
        'b': {
          'a': {'serverUrl': 'https://example.com'}
        }
      },
    );
    setUpAll(() {
      registerFallbackValue(appConfig.group('b').instance('a'));
    });

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('init, no authenticator', () async {
      // given
      DataProvider config = DataProvider(
        instanceConfig: AppInstance(group: 'b', instance: 'a'),
        graphQLDelegate: GraphQL(),
        useAuthenticator: false,
        restDelegate: Rest(),
      );
      DefaultDataProvider dp = TestDataProvider1(
        config: config,
      );
      // when
      await dp.init(appConfig);
      // then

      expect(dp.restDelegate, isNotNull);
      expect(dp.graphQLDelegate, isNotNull);
      expect(() => dp.authenticator, throwsTakkanException);
      verify(() => dp.restDelegate.init(any(), dp)).called(1);
      verify(() => dp.graphQLDelegate.init(any(), dp)).called(1);
    });

    test('init, with authenticator', () async {
      // given
      DataProvider config = DataProvider(
        instanceConfig: AppInstance(group: 'b', instance: 'a'),
        graphQLDelegate: GraphQL(),
        restDelegate: Rest(),
        useAuthenticator: true,
      );
      TestDataProvider2 dp = TestDataProvider2(
        config: config,
      );
      // when
      await dp.init(appConfig);
      // then

      expect(dp.restDelegate, isNotNull);
      expect(dp.graphQLDelegate, isNotNull);
      expect(dp.authenticator, isA<MockAuthenticator>());
    });

    test('call RestDelegate without specifying it', () async {
      // given
      DataProvider config = DataProvider(
        instanceConfig: AppInstance(group: 'b', instance: 'a'),
        graphQLDelegate: GraphQL(),
      );
      DefaultDataProvider dp = TestDataProvider2(
        config: config,
      );

      // when
      await dp.init(appConfig);
      // then

      expect(dp.graphQLDelegate, isNotNull);
      expect(() => dp.restDelegate, throwsTakkanException);
    });
    test('call GraphQLDelegate without specifying it', () async {
      // given
      DataProvider config = DataProvider(
        instanceConfig: AppInstance(group: 'b', instance: 'a'),
        restDelegate: Rest(),
      );
      DefaultDataProvider dp = TestDataProvider2(
        config: config,
      );
      // when
      await dp.init(appConfig);
      // then

      expect(dp.restDelegate, isNotNull);
      expect(() => dp.graphQLDelegate, throwsTakkanException);
    });

    test('require RestDelegate without providing construction function',
        () async {
      // given
          DataProvider config = DataProvider(
            instanceConfig: AppInstance(group: 'b', instance: 'a'),
        restDelegate: Rest(),
        useAuthenticator: true,
      );
      DefaultDataProvider dp = TestDataProvider1(
        config: config,
      );

      // when
      // then
      expect(() async {
        await dp.init(appConfig);
      }, throwsTakkanException);
    });

    test('require GraphQLDelegate without providing construction function',
        () async {
      // given
          DataProvider config = DataProvider(
        instanceConfig: AppInstance(group: 'b', instance: 'a'),
        graphQLDelegate: GraphQL(),
        useAuthenticator: true,
      );
      DefaultDataProvider dp = TestDataProvider1(config: config);

      // when
      // then
      expect(() async {
        await dp.init(appConfig);
      }, throwsTakkanException);
    });
  });
}

class TestDataProvider1 extends DefaultDataProvider<DataProvider> {
  TestDataProvider1({required DataProvider config}) : super(config: config);

  RestDataProviderDelegate createRestDelegate() {
    return MockRestDelegate();
  }

  GraphQLDataProviderDelegate createGraphQLDelegate() {
    return MockGraphQLDelegate();
  }
}

class TestDataProvider2 extends DefaultDataProvider<DataProvider> {
  TestDataProvider2({required DataProvider config}) : super(config: config);

  Future<Authenticator> createAuthenticator() async {
    final auth = MockAuthenticator();
    return auth;
  }

  RestDataProviderDelegate createRestDelegate() {
    return MockRestDelegate();
  }

  GraphQLDataProviderDelegate createGraphQLDelegate() {
    return MockGraphQLDelegate();
  }
}
