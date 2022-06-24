import 'package:graphql/client.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/delegate.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/delegate.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';

import 'data_provider.dart';

/// Equivalent to a null but throws a meaningful exception instead.
class NoDataProvider implements IDataProvider {
  static const String msg =
      'A NoDataProvider represents a condition where no data provider is available, and invoking this method is an error condition';

  const NoDataProvider();

  AppConfig get appConfig => throw TakkanException(msg);

  IDataProviderDelegate<Query> get authenticatorDelegate =>
      throw TakkanException(msg);

  GraphQLDataProviderDelegate get graphQLDelegate => throw TakkanException(msg);

  RestDataProviderDelegate get restDelegate => throw TakkanException(msg);

  SignInStatus get authStatus => throw TakkanException(msg);

  Authenticator<DataProvider, dynamic, NoDataProvider> get authenticator =>
      throw TakkanException(msg);

  DataProvider get config => throw TakkanException(msg);

  Future<Stream<Map<String, dynamic>>> connectItem() {
    throw TakkanException(msg);
  }

  Future<Stream<List<Map<String, dynamic>>>> connectList() {
    throw TakkanException(msg);
  }

  createAuthenticator() {
    throw TakkanException(msg);
  }

  DocumentId documentIdFromData(Map<String, dynamic> data) {
    throw TakkanException(msg);
  }

  /// See [IDataProvider.fetchItem]
  Future<ReadResultItem> fetchItem(
      {required Query queryConfig,
      required Map<String, dynamic> pageArguments}) {
    throw TakkanException(msg);
  }

  /// See [IDataProvider.fetchList]
  Future<ReadResultList> fetchList(
      {required Query queryConfig,
      required Map<String, dynamic> pageArguments}) {
    throw TakkanException(msg);
  }

  init({required DataProvider config, required AppConfig appConfig}) {
    throw TakkanException(msg);
  }

  TakkanUser get user => throw TakkanException(msg);

  List<String> get userRoles => throw TakkanException(msg);

  String get sessionTokenKey => 'X-Parse-Session-Token';

  @override
  Future<Script> latestScript(
      {required String locale,
      required int fromVersion,
      Delegate? useDelegate,
      required String name}) {
    throw TakkanException(msg);
  }

  @override
  Future<CreateResult> createDocument({
    required String documentClass,
    required Map<String, dynamic> data,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
  }) {
    throw TakkanException(msg);
  }

  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
  }) {
    throw TakkanException(msg);
  }

  @override
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
    required Map<String, dynamic> data,
  }) {
    throw TakkanException(msg);
  }

  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
    Delegate? useDelegate,
  }) {
    throw TakkanException(msg);
  }

  Document documentSchemaFromQuery({required String querySchemaName}) {
    throw TakkanException(msg);
  }

  @override
  Document documentSchema({required String documentSchemaName}) {
    throw TakkanException(msg);
  }

  @override
  Future<ReadResult> executeFunction(
      {required String functionName, Map<String, dynamic> params = const {}}) {
    throw TakkanException(msg);
  }

  @override
  String get objectIdKey => throw TakkanException(msg);

  @override
  bool get userIsAuthenticated => throw TakkanException(msg);

  @override
  bool get userIsNotAuthenticated => throw TakkanException(msg);

  @override
  Future<ReadResultItem> dataItem(
      {required String documentClass, required IDataItem selector}) {
    throw TakkanException(msg);
  }

  @override
  Future<ReadResultList> dataList(
      {required String documentClass, required IDataList selector}) {
    throw TakkanException(msg);
  }

  @override
  Future<ReadResultItem> executeItemFunction({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  }) {
    throw TakkanException(msg);
  }

  @override
  Future<ReadResultList> executeListFunction({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  }) {
    throw TakkanException(msg);
  }
}
