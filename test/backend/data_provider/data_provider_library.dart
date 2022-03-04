import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:test/test.dart';

void main() {
  group('DataProviderLibrary', () {
    setUpAll(() {
      dataProviderLibrary.init(AppConfig({
        'myApp': {
          'dev': {
            'type': 'default',
          }
        },
        'refApp': {
          'dev': {
            'type': 'default',
          }
        },
        'other': {
          'public': {
            'type': 'other',
          },
          'private': {
            'type': 'other',
          }
        },
      }));
    });

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('NoDataProvider', () {
      // given

      // when
      final actual =
          dataProviderLibrary.find(providerConfig: PNoDataProvider());
      // then

      expect(actual, isA<NoDataProvider>());
    });
    test('register and retrieve', () {
      // given
      final providerConfig = PDataProvider(
          sessionTokenKey: '',
          configSource: PConfigSource(segment: 'myApp', instance: 'dev'));
      final instanceConfig =
          dataProviderLibrary.appConfig.instanceConfig(providerConfig);
      // when
      dataProviderLibrary.register(type: 'default', builder: _defaultBuilder);
      // then

      expect(dataProviderLibrary.find(providerConfig: providerConfig),
          dataProviderLibrary.find(providerConfig: providerConfig),
          reason: 'Return the same (cached) instance ');
    });
    test('Multiple instances of same type', () {
      // given
      final providerConfig1 = PDataProvider(
        sessionTokenKey: '',
        configSource: PConfigSource(segment: 'myApp', instance: 'dev'),
      );
      final providerConfig2 = PDataProvider(
        sessionTokenKey: '',
        configSource: PConfigSource(segment: 'refApp', instance: 'dev'),
      );

      final instanceConfig1 =
          dataProviderLibrary.appConfig.instanceConfig(providerConfig1);

      // when
      dataProviderLibrary.register(
        type: 'default',
        builder: _defaultBuilder,
      );
      // then

      expect(
        dataProviderLibrary.find(providerConfig: providerConfig2),
        isNotNull,
        reason: 'same type, already registered',
      );
      expect(dataProviderLibrary.find(providerConfig: providerConfig1),
          dataProviderLibrary.find(providerConfig: providerConfig1),
          reason: 'Return the same (cached) instance ');
      expect(
          dataProviderLibrary.find(providerConfig: providerConfig1),
          isNot(
            dataProviderLibrary.find(providerConfig: providerConfig2),
          ),
          reason: 'Different cached instance');
    });
    test('Multiple instances, multiple types', () {
      // given
      final providerConfig1 = PDataProvider(
        sessionTokenKey: '',
        configSource: PConfigSource(segment: 'myApp', instance: 'dev'),
      );
      final providerConfig2 = PDataProvider(
        sessionTokenKey: '',
        configSource: PConfigSource(segment: 'refApp', instance: 'dev'),
      );
      final providerConfig3 = PDataProvider(
        sessionTokenKey: '',
        configSource: PConfigSource(segment: 'other', instance: 'public'),
      );
      final providerConfig4 = PDataProvider(
        sessionTokenKey: '',
        configSource: PConfigSource(segment: 'other', instance: 'private'),
      );
      // when
      dataProviderLibrary.register(
        type: 'default',
        builder: _defaultBuilder,
      );
      dataProviderLibrary.register(
        type: 'other',
        builder: _otherBuilder,
      );
      // then

      expect(
        dataProviderLibrary.find(providerConfig: providerConfig2),
        isNotNull,
        reason: 'same type, already registered',
      );
      final find1 = dataProviderLibrary.find(providerConfig: providerConfig1);
      final find2 = dataProviderLibrary.find(providerConfig: providerConfig2);
      final find3 = dataProviderLibrary.find(providerConfig: providerConfig3);
      final find4 = dataProviderLibrary.find(providerConfig: providerConfig4);

      expect(find1, isA<DefaultDataProvider>());
      expect(find3, isA<OtherDataProvider>());

      expect(find1.runtimeType, find2.runtimeType);
      expect(find3.runtimeType, find4.runtimeType);
      expect(find1.runtimeType, isNot(find4.runtimeType));

      expect(find1, find1, reason: 'Return the same (cached) instance ');
      expect(find3, find3, reason: 'Return the same (cached) instance ');
      expect(find1, isNot(find2), reason: 'Different cached instance');
      expect(find3, isNot(find4), reason: 'Different cached instance');
    });
    test('unregistered', () {
      // given
      dataProviderLibrary.clear();
      final providerConfig = PDataProvider(
          sessionTokenKey: '',
          configSource: PConfigSource(segment: 'myApp', instance: 'dev'));

      // when

      // then
      expect(() => dataProviderLibrary.find(providerConfig: providerConfig),
          throwsA(isA<PreceptException>()));
    });
  });
}

DataProvider<PDataProvider> _defaultBuilder(PDataProvider config) {
  return DefaultDataProvider(config: config);
}

OtherDataProvider _otherBuilder(PDataProvider config) {
  return OtherDataProvider(config: config);
}

class OtherDataProvider extends DefaultDataProvider<PDataProvider> {
  OtherDataProvider({required PDataProvider config}) : super(config: config);
}
