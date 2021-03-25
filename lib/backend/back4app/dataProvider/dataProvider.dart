import 'package:flutter/foundation.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/dataProvider/graphqlDataProvider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';

class Back4AppDataProvider extends GraphQLDataProvider<PBack4AppDataProvider> {
  Back4AppDataProvider({@required PBack4AppDataProvider config}) : super(config: config);

  @override
  Authenticator<PBack4AppDataProvider> createAuthenticator(PBack4AppDataProvider config) =>
      Back4AppAuthenticator(config: config);
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        config: PBack4AppDataProvider, builder: (config) => Back4AppDataProvider(config: config));
  }
}
