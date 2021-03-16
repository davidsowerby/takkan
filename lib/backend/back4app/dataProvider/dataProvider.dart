import 'package:flutter/foundation.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/dataProvider/restDataProvider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/script/dataProvider.dart';

class Back4AppDataProvider extends RestDataProvider {
  Back4AppDataProvider({@required PBack4AppDataProvider config}) : super(config: config);

  @override
  Authenticator<PDataProvider> get authenticator => Back4AppAuthenticator(config: config);
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        config: PBack4AppDataProvider, builder: (config) => Back4AppDataProvider(config: config));
  }
}
