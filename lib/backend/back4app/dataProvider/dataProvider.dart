import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/documentId.dart';

class Back4AppDataProvider extends DataProvider<PBack4AppDataProvider> {
  Back4AppDataProvider({@required PBack4AppDataProvider config}) : super(config: config);

  @override
  Authenticator<PBack4AppDataProvider, ParseUser> createAuthenticator(
          PBack4AppDataProvider config) =>
      Back4AppAuthenticator(config: config);

  @override
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(path: data['__typename'], itemId: data['objectId']);
  }
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        config: PBack4AppDataProvider, builder: (config) => Back4AppDataProvider(config: config));
  }
}
