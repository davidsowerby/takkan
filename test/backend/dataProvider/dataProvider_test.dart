import 'package:mocktail/mocktail.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/graphqlDelegate.dart';
import 'package:precept_script/data/provider/restDelegate.dart';
import 'package:test/test.dart';

import '../../fixtures/matchers.dart';
import '../../fixtures/mocks.dart';

void main() {
  group('DefaultDataProvider', () {
    AppConfig appConfig = AppConfig({
      'b': {
        'a': {'serverUrl': 'https://example.com'}
      }
    });
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('init, no authenticator', () async {
      // given
      PDataProvider config = PDataProvider(
        providerName: 'Test',
        headerKeys: ['a'],
        configSource: PConfigSource(segment: 'b', instance: 'a'),
        sessionTokenKey: 'sessionToken',
        graphQLDelegate: PGraphQL(sessionTokenKey: 'sessionToken'),
        useAuthenticator: false,
        restDelegate: PRest(sessionTokenKey: 'sessionToken'),
      );
      DefaultDataProvider dp = TestDataProvider1(
        config: config,
      );
      // when
      await dp.init(appConfig);
      // then

      expect(dp.restDelegate, isNotNull);
      expect(dp.graphQLDelegate, isNotNull);
      expect(() => dp.authenticator, throwsPreceptException);
      verify(() => dp.restDelegate.init(appConfig, dp)).called(1);
      verify(() => dp.graphQLDelegate.init(appConfig, dp)).called(1);
    });

    test('init, with authenticator', () async {
      // given
      PDataProvider config = PDataProvider(
        providerName: 'Test',
        headerKeys: ['a'],
        configSource: PConfigSource(segment: 'b', instance: 'a'),
        sessionTokenKey: 'sessionToken',
        graphQLDelegate: PGraphQL(sessionTokenKey: 'sessionToken'),
        restDelegate: PRest(sessionTokenKey: 'sessionToken'),
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
      PDataProvider config = PDataProvider(
        providerName: 'Test',
        headerKeys: ['a'],
        configSource: PConfigSource(segment: 'b', instance: 'a'),
        sessionTokenKey: 'sessionToken',
        graphQLDelegate: PGraphQL(sessionTokenKey: 'sessionToken'),
      );
      DefaultDataProvider dp = TestDataProvider2(
        config: config,
      );

      // when
      await dp.init(appConfig);
      // then

      expect(dp.graphQLDelegate, isNotNull);
      expect(() => dp.restDelegate, throwsPreceptException);
    });
    test('call GraphQLDelegate without specifying it', () async {
      // given
      PDataProvider config = PDataProvider(
        providerName: 'Test',
        headerKeys: ['a'],
        configSource: PConfigSource(segment: 'b', instance: 'a'),
        sessionTokenKey: 'sessionToken',
        restDelegate: PRest(sessionTokenKey: 'sessionToken'),
      );
      DefaultDataProvider dp = TestDataProvider2(
        config: config,
      );
      // when
      await dp.init(appConfig);
      // then

      expect(dp.restDelegate, isNotNull);
      expect(() => dp.graphQLDelegate, throwsPreceptException);
    });

    test('require RestDelegate without providing construction function',
        () async {
      // given
      PDataProvider config = PDataProvider(
        providerName: 'Test',
        headerKeys: ['a'],
        configSource: PConfigSource(segment: 'b', instance: 'a'),
        sessionTokenKey: 'sessionToken',
        restDelegate: PRest(sessionTokenKey: 'sessionToken'),
        useAuthenticator: true,
      );
      DefaultDataProvider dp = TestDataProvider1(
        config: config,
      );

      // when

      // then
      expect(() async {
        await dp.init(appConfig);
      }, throwsPreceptException);
    });

    test('require GraphQLDelegate without providing construction function',
        () async {
      // given
      PDataProvider config = PDataProvider(
        providerName: 'Test',
        headerKeys: ['a'],
        configSource: PConfigSource(segment: 'b', instance: 'a'),
        sessionTokenKey: 'sessionToken',
        graphQLDelegate: PGraphQL(sessionTokenKey: 'sessionToken'),
        useAuthenticator: true,
      );
      DefaultDataProvider dp = TestDataProvider1(config: config);

      // when

      // then
      expect(() async {
        await dp.init(appConfig);
      }, throwsPreceptException);
    });
  });
}

class TestDataProvider1 extends DefaultDataProvider<PDataProvider> {
  TestDataProvider1({required PDataProvider config}) : super(config: config);

  RestDataProviderDelegate createRestDelegate() {
    return MockRestDelegate();
  }

  GraphQLDataProviderDelegate createGraphQLDelegate() {
    return MockGraphQLDelegate();
  }
}

class TestDataProvider2 extends DefaultDataProvider<PDataProvider> {
  TestDataProvider2({required PDataProvider config}) : super(config: config);

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
