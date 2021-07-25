import 'package:flutter/foundation.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/graphqlDelegate.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/restDelegate.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/documentId.dart';

class Back4AppDataProvider extends DefaultDataProvider<PBack4AppDataProvider> {
  Back4AppDataProvider({required PBack4AppDataProvider config})
      : super(config: config);

  @protected
  Back4AppGraphQLDelegate createGraphQLDelegate() {
    return Back4AppGraphQLDelegate(this);
  }

  @protected
  Back4AppRestDelegate createRestDelegate() {
    return Back4AppRestDelegate(this);
  }

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
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        configType: PBack4AppDataProvider,
        builder: (config) =>
            Back4AppDataProvider(config: config as PBack4AppDataProvider));
  }
}
