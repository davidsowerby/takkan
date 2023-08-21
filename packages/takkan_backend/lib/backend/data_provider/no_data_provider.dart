import 'package:graphql/client.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/delegate.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data_selector.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/script/script.dart';

import '../app/app_config.dart';
import '../user/authenticator.dart';
import '../user/takkan_user.dart';
import 'data_provider.dart';
import 'result.dart';

/// Equivalent to a null but throws a meaningful exception instead.
class NoDataProvider implements IDataProvider {
  const NoDataProvider();
  static const String msg =
      'A NoDataProvider represents a condition where no data provider is available, and invoking this method is an error condition';

  AppConfig get appConfig => throw const TakkanException(msg);

  SignInStatus get authStatus => throw const TakkanException(msg);

  @override
  Authenticator<DataProvider, dynamic> get authenticator =>
      throw const TakkanException(msg);

  @override
  DataProvider get config => throw const TakkanException(msg);

  Future<Stream<Map<String, dynamic>>> connectItem() {
    throw const TakkanException(msg);
  }

  Future<Stream<List<Map<String, dynamic>>>> connectList() {
    throw const TakkanException(msg);
  }

  @override
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    throw const TakkanException(msg);
  }

  /// See [IDataProvider.fetchDocument]
  @override
  Future<ReadResultItem> fetchDocument({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  }) {
    throw const TakkanException(msg);
  }

  /// See [IDataProvider.fetchDocList]
  Future<ReadResultList> fetchDocList({
    required String functionName,
    Map<String, dynamic> variables = const {},
    required String documentClass,
  }) {
    throw const TakkanException(msg);
  }

  @override
  Future<void> init({required DataProvider config}) {
    throw const TakkanException(msg);
  }

  @override
  TakkanUser get user => throw const TakkanException(msg);

  @override
  Set<String> get userRoles => throw const TakkanException(msg);

  @override
  String get sessionTokenKey => 'X-Parse-Session-Token';

  @override
  Future<Script> latestScript(
      {required String locale,
      required int fromVersion,
      Delegate? useDelegate,
      required String name}) {
    throw const TakkanException(msg);
  }

  @override
  Future<CreateResult> createDocument({
    required String documentClass,
    required Map<String, dynamic> data,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
  }) {
    throw const TakkanException(msg);
  }

  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
  }) {
    throw const TakkanException(msg);
  }

  @override
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
    required Map<String, dynamic> data,
  }) {
    throw const TakkanException(msg);
  }

  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    FetchPolicy? fetchPolicy,
    Delegate? useDelegate,
  }) {
    throw const TakkanException(msg);
  }

  @override
  Future<FunctionResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  }) {
    throw const TakkanException(msg);
  }

  @override
  String get objectIdKey => throw const TakkanException(msg);

  @override
  bool get userIsAuthenticated => throw const TakkanException(msg);

  @override
  bool get userIsNotAuthenticated => throw const TakkanException(msg);

  @override
  Future<ReadResult<dynamic>> executeGraphQL({
    required String script,
    FetchPolicy? fetchPolicy,
    FieldSelector? fieldSelector,
  }) {
    throw const TakkanException(msg);
  }

  @override
  Future<ReadResultList> fetchDocumentList(
      {required String functionName,
      required String documentClass,
      Map<String, dynamic> params = const {}}) {
    throw const TakkanException(msg);
  }

  @override
  Future<ReadResultItem> selectDocument(
      {required DocumentSelector selector,
      required String documentClass,
      Map<String, dynamic> pageArguments = const {}}) {
    throw const TakkanException(msg);
  }

  @override
  Future<ReadResultList> selectDocumentList({
    required DocumentListSelector selector,
    required String documentClass,
    Map<String, dynamic> pageArguments = const {},
  }) {
    throw const TakkanException(msg);
  }
}
