import 'package:graphql/client.dart';
import 'package:precept_backend/backend/app/appConfig.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/fieldSelector.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/restQuery.dart';

abstract class DataProviderDelegate<QUERY extends PQuery> {
  DataProvider get parent;

  init(InstanceConfig instanceConfig, DataProvider parent);

  /// See [DataProvider.fetchItem]
  Future<ReadResultItem> fetchItem(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// See [DataProvider.fetchList]
  Future<ReadResultList> fetchList(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// See [DataProvider.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
    FieldSelector fieldSelector = const FieldSelector(),
  });

  setSessionToken(String token);

  assembleScript(QUERY queryConfig, Map<String, dynamic> pageArguments);

  Future<ReadResultItem> latestScript(
      {required String locale, required int fromVersion, required String name});

  /// See [DataProvider.deleteDocument]
  Future<DeleteResult> deleteDocument({required DocumentId documentId});

  /// See [DataProvider.createDocument]
  Future<CreateResult> createDocument({
    required String path,
    required Map<String, dynamic> data,
    FieldSelector fieldSelector = const FieldSelector(),
  });

  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
  });
}

/// Defined as an interface to enable injection of alternative implementations
abstract class RestDataProviderDelegate
    implements DataProviderDelegate<PRestQuery> {}

/// Defined as an interface to enable injection of alternative implementations
abstract class GraphQLDataProviderDelegate
    implements DataProviderDelegate<PGraphQLQuery> {}
