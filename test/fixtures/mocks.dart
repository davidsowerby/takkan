import 'package:mocktail/mocktail.dart';
import 'package:precept_backend/backend/data_provider/delegate.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/data_provider.dart';

class MockAuthenticator extends Mock implements Authenticator {}

Future<Authenticator> createMockAuthenticator() async {
  return MockAuthenticator();
}

class MockGraphQLDelegate extends Mock implements GraphQLDataProviderDelegate {}

class MockRestDelegate extends Mock implements RestDataProviderDelegate {}

MockGraphQLDelegate createMockGraphQLDelegate() {
  final delegate = MockGraphQLDelegate();
  return delegate;
}

MockRestDelegate createMockRestDelegate() {
  return MockRestDelegate();
}

class MockPDataProvider extends Mock implements PDataProvider {}
