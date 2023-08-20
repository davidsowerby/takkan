import 'package:mocktail/mocktail.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/data/provider/data_provider.dart';

class MockAuthenticator extends Mock
    implements Authenticator<DataProvider, TakkanUser> {}

Future<Authenticator<DataProvider, dynamic>> createMockAuthenticator() async {
  return MockAuthenticator();
}

class MockDataProviderConfig extends Mock implements DataProvider {}

class MockDataProvider extends Mock implements IDataProvider {}
