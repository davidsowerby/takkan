import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/delegate.dart';
import 'package:takkan_backend/backend/data_provider/query_selector.dart';
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
import 'package:takkan_script/data/select/rest_query.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/inject/inject.dart';

import 'data_provider.dart';

/// Routes all calls to the [graphQLDelegate]
class BaseDataProvider<CONFIG extends DataProvider>
    implements IDataProvider<CONFIG>, QuerySelector {
  late CONFIG config;
  late Authenticator _authenticator;
  RestDataProviderDelegate? _restDelegate;
  GraphQLDataProviderDelegate? _graphQLDelegate;
  late InstanceConfig _instanceConfig;
  late QuerySelector querySelector;

  BaseDataProvider();

  List<String> get userRoles => authenticator.userRoles;

  InstanceConfig get instanceConfig => _instanceConfig;

  Authenticator get authenticator => _authenticator;

  RestDataProviderDelegate get restDelegate {
    if (_restDelegate != null) {
      return _restDelegate!;
    }
    throw TakkanException(
        'You have used a PRestQuery but no REST delegate Make sure you have set config.restQLDelegate');
  }

  GraphQLDataProviderDelegate get graphQLDelegate {
    if (_graphQLDelegate != null) {
      return _graphQLDelegate!;
    }
    throw TakkanException(
        'No GraphQL delegate has been constructed.  Make sure you have set config.graphQLDelegate');
  }

  @mustCallSuper
  init({required CONFIG config, required AppConfig appConfig}) async {
    this.config = config;
    final instanceConfig = appConfig.instanceConfig(config);
    this._instanceConfig = instanceConfig;
    _restDelegate = inject<RestDataProviderDelegate>(
        instanceName: instanceConfig.uniqueName);

    restDelegate.init(instanceConfig, this);
    if (config.graphQLDelegate != null) {
      _graphQLDelegate = inject<GraphQLDataProviderDelegate>(
          instanceName: instanceConfig.uniqueName);
      graphQLDelegate.init(instanceConfig, this);
    }

    querySelector =
        inject<QuerySelector>(instanceName: instanceConfig.uniqueName);
    _authenticator =
        inject<Authenticator>(instanceName: instanceConfig.uniqueName);
    _authenticator.init();
  }

  TakkanUser get user => authenticator.user;

  bool get userIsAuthenticated => authenticator.isAuthenticated;

  bool get userIsNotAuthenticated => authenticator.isNotAuthenticated;

  SignInStatus get authStatus => authenticator.status;

  IDataProviderDelegate get defaultDelegate {
    switch (config.defaultDelegate) {
      case Delegate.graphQl:
        return graphQLDelegate;
      case Delegate.rest:
        return restDelegate;
    }
  }

  /// see [IDataProvider.fetchItem]
  Future<ReadResultItem> fetchItem({
    required Query queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final Map<String, dynamic> variables =
    combineVariables(queryConfig, pageArguments);
    return _delegateFromQueryType(queryConfig: queryConfig)
        .fetchItem(queryConfig, variables);
  }

  /// Returns a Future of a list of one or more document instances
  Future<ReadResultList> fetchList({
    required Query queryConfig,
    required Map<String, dynamic> pageArguments,
  }) async {
    final Map<String, dynamic> variables =
    combineVariables(queryConfig, pageArguments);
    return _delegateFromQueryType(queryConfig: queryConfig)
        .fetchList(queryConfig, variables);
  }

  /// Returns a stream of document
  Future<Stream<Map<String, dynamic>>> connectItem() {
    throw UnimplementedError();
  }

  /// Returns a stream of document list
  Future<Stream<List<Map<String, dynamic>>>> connectList() {
    throw UnimplementedError();
  }

  /// See [IDataProvider.createDocument]
  Future<CreateResult> createDocument({
    required String documentClass,
    required Map<String, dynamic> data,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
  }) async {
    return await _selectDelegate(useDelegate).createDocument(
        documentClass: documentClass, data: data, documentIdKey: objectIdKey);
  }

  /// Executes a server-side (cloud) function.  Always uses the [restDelegate]
  Future<ReadResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  }) async {
    return await restDelegate.executeFunction(
      functionName: functionName,
      params: params,
    );
  }

  /// Executes a server side server-side function [functionName], with [params]
  /// Always returns a single document unless success==false in the returned result
  Future<ReadResultItem> executeItemFunction({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  }) async {
    return await restDelegate.executeItemFunction(
      documentClass: documentClass,
      functionName: functionName,
      params: params,
    );
  }

  /// Executes a server side server-side function [functionName], with [params]
  /// Always returns a list of documents unless success==false in the returned result
  Future<ReadResultList> executeListFunction({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  }) async {
    return await restDelegate.executeListFunction(
      documentClass: documentClass,
      functionName: functionName,
      params: params,
    );
  }

  /// See [IDataProvider.updateDocument]
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
    required Map<String, dynamic> data,
  }) async {
    return await _selectDelegate(useDelegate)
        .updateDocument(documentId: documentId, data: data);
  }

  /// Once a document has been created, it should be possible to create a unique id for it
  /// from its data, but the manner of doing so is implementation specific.
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(documentClass: 'unknown', objectId: 'unknown');
  }

  /// Combines variable values from 3 possible sources. Order of precedence is:
  ///
  /// 1. [PQuery.variables]
  /// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
  /// 1. Values passed as [pageArguments]
  @protected
  Map<String, dynamic> combineVariables(Query query,
      Map<String, dynamic> pageArguments) {
    final variables = Map<String, dynamic>();
    final propertyVariables = _buildPropertyVariables(query.propertyReferences);
    variables.addAll(pageArguments);
    variables.addAll(propertyVariables);
    variables.addAll(query.variables);
    return variables;
  }

// TODO: get variable values from property references
  Map<String, dynamic> _buildPropertyVariables(
      List<String> propertyReferences) {
    return {};
  }

  @override
  Future<Script> latestScript({required String locale,
    required int fromVersion,
    Delegate? useDelegate,
    required String name}) async {
    final ReadResultItem result = await _selectDelegate(useDelegate)
        .latestScript(locale: locale, fromVersion: fromVersion, name: name);
    return Script.fromJson(result.data);
  }

  /// If the [restDelegate] available, calls it to delete the document,
  /// otherwise call the [graphQLDelegate] to execute the delete.
  ///
  /// see [IDataProvider.deleteDocument]
  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
    Delegate? useDelegate,
  }) async {
    return await _selectDelegate(useDelegate)
        .deleteDocument(documentId: documentId);
  }

  ///
  /// see [IDataProvider.readDocument]
  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
    Delegate? useDelegate,
    FetchPolicy? fetchPolicy,
  }) async {
    return await _selectDelegate(useDelegate)
        .readDocument(documentId: documentId);
  }

  Document documentSchema({required String documentSchemaName}) {
    return config.script.documentSchema(documentSchemaName: documentSchemaName);
  }

  IDataProviderDelegate _delegateFromQueryType({
    required Query queryConfig,
  }) {
    if (queryConfig is GraphQLQuery) {
      if (_graphQLDelegate != null) {
        return graphQLDelegate;
      } else {
        throw TakkanException(
            'In order to use a ${queryConfig.runtimeType
                .toString()}, a graphQLDelegate must be specified in DataProvider');
      }
    }
    if (queryConfig is RestQuery) {
      if (_restDelegate != null) {
        return restDelegate;
      } else {
        throw TakkanException(
            'In order to use a ${queryConfig.runtimeType
                .toString()}, a restDelegate must be specified in DataProvider');
      }
    }
    throw TakkanException(
        'No delegate available to support a ${queryConfig.runtimeType
            .toString()}');
  }

  IDataProviderDelegate _selectDelegate(Delegate? selectedDelegate) {
    final Delegate selection = selectedDelegate ?? config.defaultDelegate;
    switch (selection) {
      case Delegate.graphQl:
        return graphQLDelegate;
      case Delegate.rest:
        return restDelegate;
    }
  }

  @override
  String get sessionTokenKey => 'X-Parse-Session-Token';

  /// The property name for the field which provides a document's unique id
  @override
  String get objectIdKey => 'objectId';

  @override
  Future<ReadResultItem> dataItem({
    required String documentClass,
    required IDataItem selector,
  }) {
    return querySelector.dataItem(
        documentClass: documentClass, selector: selector);
  }

  @override
  Future<ReadResultList> dataList({
    required String documentClass,
    required IDataList selector,
  }) {
    return querySelector.dataList(
        documentClass: documentClass, selector: selector);
  }
}
