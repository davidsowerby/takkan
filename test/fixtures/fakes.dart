import 'package:flutter_test/flutter_test.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/user/authenticator.dart';

class FakeAuthenticator extends Fake implements Authenticator {}

class FakeGraphQLDelegate extends Fake implements GraphQLDataProviderDelegate {}

class FakeRestDelegate extends Fake implements RestDataProviderDelegate {}
