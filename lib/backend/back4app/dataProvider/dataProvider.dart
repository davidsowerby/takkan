import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/graphqlDelegate.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/dataProvider/delegate.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';

class Back4AppDataProvider extends DefaultDataProvider<PBack4AppDataProvider> {
  Back4AppDataProvider({required PBack4AppDataProvider config})
      : super(
          config: config,
        );

  String get applicationId {
    final String? appId =
        appConfig.instanceConfig(config)['X-Parse-Application-Id'];
    if (appId == null) {
      throw PreceptException(
          'An applicationId must be specified in precept.json using key: X-Parse-Application-Id ');
    }
    return appId;
  }

  String get clientKey {
    final String? appId =
        appConfig.instanceConfig(config)['X-Parse-Client-Key'];
    if (appId == null) {
      throw PreceptException(
          'An applicationId must be specified in precept.json using key: X-Parse-Client-Key ');
    }
    return appId;
  }

  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(path: data['__typename'], itemId: data['objectId']);
  }

  Future<Authenticator> createAuthenticator() async {
    return Back4AppAuthenticator();
  }

  GraphQLDataProviderDelegate createGraphQLDelegate() {
    return Back4AppGraphQLDelegate();
  }
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        configType: PBack4AppDataProvider,
        builder: (config) =>
            Back4AppDataProvider(config: config as PBack4AppDataProvider));
  }
}

Back4AppGraphQLDelegate constructGraphQLDelegate() {
  return Back4AppGraphQLDelegate();
}

Future<Authenticator<PDataProvider, ParseUser, Back4AppDataProvider>>
    constructAuthenticator() async {
  return Back4AppAuthenticator();
}
