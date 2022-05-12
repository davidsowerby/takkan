import 'package:graphql/client.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/data/select/field_selector.dart';
import 'package:precept_script/data/select/query.dart';
import 'package:precept_script/data/select/rest_query.dart';

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
    required String documentClass,
    required Map<String, dynamic> data,
    required String documentIdKey,
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
    implements DataProviderDelegate<PRestQuery> {
  Future<ReadResult> executeFunction(
      {required String functionName, Map<String, dynamic> params = const {}});
}

/// Defined as an interface to enable injection of alternative implementations
abstract class GraphQLDataProviderDelegate
    implements DataProviderDelegate<PGraphQLQuery> {}
