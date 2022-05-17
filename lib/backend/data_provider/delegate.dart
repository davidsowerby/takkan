import 'package:graphql/client.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/data/select/rest_query.dart';

abstract class IDataProviderDelegate<QUERY extends Query> {
  IDataProvider get parent;

  init(InstanceConfig instanceConfig, IDataProvider parent);

  /// See [IDataProvider.fetchItem]
  Future<ReadResultItem> fetchItem(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// See [IDataProvider.fetchList]
  Future<ReadResultList> fetchList(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// See [IDataProvider.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
    FieldSelector fieldSelector = const FieldSelector(),
  });

  setSessionToken(String token);

  assembleScript(QUERY queryConfig, Map<String, dynamic> pageArguments);

  Future<ReadResultItem> latestScript(
      {required String locale, required int fromVersion, required String name});

  /// See [IDataProvider.deleteDocument]
  Future<DeleteResult> deleteDocument({required DocumentId documentId});

  /// See [IDataProvider.createDocument]
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
    implements IDataProviderDelegate<RestQuery> {
  Future<ReadResult> executeFunction(
      {required String functionName, Map<String, dynamic> params = const {}});
}

/// Defined as an interface to enable injection of alternative implementations
abstract class GraphQLDataProviderDelegate
    implements IDataProviderDelegate<GraphQLQuery> {}
