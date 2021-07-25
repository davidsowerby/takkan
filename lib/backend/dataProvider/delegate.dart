import 'dart:ui';

import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/fieldSelector.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/restQuery.dart';
import 'package:precept_script/script/script.dart';

abstract class DataProviderDelegate<QUERY extends PQuery> {
  DataProvider get parent;

  init(AppConfig appConfig);

  /// Executes a query expecting a single result
  Future<Map<String, dynamic>> fetchItem(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// Executes a query expecting 0..n results
  Future<List<Map<String, dynamic>>> fetchList(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// See [DataProvider.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
  });

  setSessionToken(String token);

  assembleScript(QUERY queryConfig, Map<String, dynamic> pageArguments);

  Future<Authenticator> createAuthenticator();

  Future<UpdateResult> uploadPreceptScript({
    required PScript script,
    required Locale locale,
    bool incrementVersion = false,
  });

  Future<ReadResult> latestScript(
      {required Locale locale, required int fromVersion, required String name});

  /// See [DataProvider.deleteDocument]
  Future<DeleteResult> deleteDocument({required DocumentId documentId});

  /// See [DataProvider.createDocument]
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<ReadResult> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
  });

  Authenticator get authenticator;
}

/// Defined as an interface to enable injection of alternative implementations
abstract class RestDataProviderDelegate
    implements DataProviderDelegate<PRestQuery> {}

/// Defined as an interface to enable injection of alternative implementations
abstract class GraphQLDataProviderDelegate
    implements DataProviderDelegate<PGraphQLQuery> {}
