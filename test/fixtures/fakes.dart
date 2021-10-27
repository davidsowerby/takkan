import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:test/fake.dart';

class FakeAuthenticator extends Fake implements Authenticator {}

class FakeGraphQLDelegate extends Fake implements GraphQLDataProviderDelegate {}

class FakeRestDelegate extends Fake implements RestDataProviderDelegate {}
