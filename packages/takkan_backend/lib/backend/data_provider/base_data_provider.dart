import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/delegate.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/data/select/data_selector.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/script/script.dart';

import '../app/app_config.dart';
import '../user/authenticator.dart';
import '../user/takkan_user.dart';
import 'data_provider.dart';
import 'result.dart';
import 'result_transformer.dart';
import 'server_connect.dart';
import 'url_builder.dart';

abstract class BaseDataProvider<CONFIG extends DataProvider,
    USER extends Object> implements IDataProvider<CONFIG> {
  BaseDataProvider();

  @override
  late CONFIG config;
  late Authenticator<CONFIG, USER> _authenticator;
  late InstanceConfig _instanceConfig;
  late RestServerConnect serverConnect;
  late URLBuilder urlBuilder;
  late ResultTransformer resultTransformer;

  @override
  Set<String> get userRoles => authenticator.userRoles;

  InstanceConfig get instanceConfig => _instanceConfig;

  @override
  Authenticator<CONFIG, USER> get authenticator => _authenticator;

  @override
  @mustCallSuper
  Future<void> init({required CONFIG config}) async {
    this.config = config;
    final AppConfig appConfig = inject<AppConfig>();
    final instanceConfig = appConfig.instanceConfig(config);
    _instanceConfig = instanceConfig;
    serverConnect =
        inject<RestServerConnect>(instanceName: instanceConfig.uniqueName);
    _authenticator = inject<Authenticator<CONFIG, USER>>(
        instanceName: instanceConfig.uniqueName);
    urlBuilder = inject<URLBuilder>(instanceName: instanceConfig.uniqueName);
    resultTransformer =
        inject<ResultTransformer>(instanceName: instanceConfig.uniqueName);
    _authenticator.init();
  }

  @override
  TakkanUser get user => authenticator.user;

  @override
  bool get userIsAuthenticated => authenticator.isAuthenticated;

  @override
  bool get userIsNotAuthenticated => authenticator.isNotAuthenticated;

  String get documentEndpoint => instanceConfig.documentEndpoint;

  String get functionEndpoint => instanceConfig.functionEndpoint;

  SignInStatus get authStatus => authenticator.status;

  /// see [IDataProvider.fetchDocument]
  /// The request is set to [URLRequest.functionItem] as this is using cloud
  /// function to fetch the document
  @override
  Future<ReadResultItem> fetchDocument(
      {required String functionName,
      required String documentClass,
      Map<String, dynamic> params = const {}}) async {
    const requestType = URLRequest.functionItem;
    final serverConnectResponse = await serverConnect.fetch(
      instanceConfig: instanceConfig,
      urlComposition: urlBuilder.build(
        request: requestType,
        params: params,
        instanceConfig: instanceConfig,
        functionName: functionName,
      ),
    );

    return ReadResultItem(
      data: resultTransformer.transform(
        rawResponse: serverConnectResponse,
        requestType: requestType,
      ),
      documentClass: documentClass,
      returnSingle: true,
      success: true,
    );
  }

  /// see [IDataProvider.fetchDocumentList]
  @override
  Future<ReadResultList> fetchDocumentList({
    required String functionName,
    required String documentClass,
    Map<String, dynamic> params = const {},
  }) async {
    const requestType = URLRequest.functionList;
    final serverConnectResponse = await serverConnect.fetch(
      instanceConfig: instanceConfig,
      urlComposition: urlBuilder.build(
        request: requestType,
        instanceConfig: instanceConfig,
        functionName: functionName,
        params: params,
      ),
    );
    return ReadResultList(
      data: resultTransformer.transformList(
        rawResponse: serverConnectResponse,
        requestType: requestType,
      ),
      documentClass: documentClass,
      success: true,
    );
  }

  @override
  Future<ReadResultItem> selectDocument({
    required DocumentSelector selector,
    required String documentClass,
    Map<String, dynamic> pageArguments = const {},
  }) {
    final params = combineVariables(selector, pageArguments);
    final s = selector;
    if (s is DocByQuery) {
      return fetchDocument(
        functionName: s.queryName,
        documentClass: documentClass,
        params: params,
      );
    }
    throw UnimplementedError();
  }

  /// See [IDataProvider.selectDocumentList]
  @override
  Future<ReadResultList> selectDocumentList({
    required DocumentListSelector selector,
    required String documentClass,
    Map<String, dynamic> pageArguments = const {},
  }) {
    final params = combineVariables(selector, pageArguments);
    final s = selector;
    if (s is DocListByQuery) {
      return fetchDocumentList(
        functionName: s.queryName,
        documentClass: documentClass,
        params: params,
      );
    }
    throw UnimplementedError();
  }

  /// See [IDataProvider.createDocument]
  @override
  Future<CreateResult> createDocument({
    required String documentClass,
    required Map<String, dynamic> data,
    Delegate? useDelegate,
    FieldSelector fieldSelector = const FieldSelector(),
  }) async {
    logType(runtimeType).d('Creating new document');
    final urlComposition = urlBuilder.build(
      request: URLRequest.createDoc,
      documentClass: documentClass,
      instanceConfig: instanceConfig,
    );

    final serverConnectResponse = await serverConnect.create(
        instanceConfig: instanceConfig, url: urlComposition.url, data: data);

    final returnedData = resultTransformer.transform(
      rawResponse: serverConnectResponse,
      requestType: URLRequest.createDoc,
    );
    return CreateResult(
      documentClass: documentClass,
      data: returnedData,
      success: true,
      objectId: returnedData[objectIdKey] as String? ?? '?',
    );
  }

  @override
  Future<ReadResultItem> readDocument({
    required DocumentId documentId,
  }) async {
    logType(runtimeType).d('Reading document');

    final urlComposition = urlBuilder.build(
      request: URLRequest.readDoc,
      instanceConfig: instanceConfig,
      documentId: documentId,
    );
    final serverConnectResponse = await serverConnect.read(
      instanceConfig: instanceConfig,
      url: urlComposition.url,
    );

    return ReadResultItem(
      documentClass: documentId.documentClass,
      data: resultTransformer.transform(
        rawResponse: serverConnectResponse,
        requestType: URLRequest.readDoc,
      ),
      success: true,
      returnSingle: true,
    );
  }

  /// see [IDataProvider.deleteDocument]
  @override
  Future<DeleteResult> deleteDocument({
    required DocumentId documentId,
  }) async {
    logType(runtimeType).d('Deleting document');
    final urlComposition = urlBuilder.build(
      request: URLRequest.deleteDoc,
      instanceConfig: instanceConfig,
      documentId: documentId,
    );
    final serverConnectResponse = await serverConnect.delete(
      instanceConfig: instanceConfig,
      url: urlComposition.url,
    );

    return DeleteResult(
      documentClass: documentId.documentClass,
      data: resultTransformer.transform(
        rawResponse: serverConnectResponse,
        requestType: URLRequest.deleteDoc,
      ),
      success: true,
      objectId: documentId.objectId,
    );
  }

  /// See [IDataProvider.updateDocument]
  @override
  Future<UpdateResult> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> data,
  }) async {
    logType(runtimeType).d('Updating document');
    final serverConnectResponse = await serverConnect.update(
      instanceConfig: instanceConfig,
      url: '$documentEndpoint/${documentId.documentClass}',
      data: data,
      documentId: documentId,
    );

    return UpdateResult(
      documentClass: documentId.documentClass,
      data: resultTransformer.transform(
        rawResponse: serverConnectResponse,
        requestType: URLRequest.updateDoc,
      ),
      success: true,
      objectId: documentId.objectId,
    );
  }

  /// Executes a server-side (cloud) function.  Always uses the [restDelegate]
  @override
  Future<FunctionResult> executeFunction({
    required String functionName,
    Map<String, dynamic> params = const {},
  }) async {
    logType(runtimeType).d('Executing function $functionName');
    final serverConnectResponse = await serverConnect.executeFunction(
      function: functionName,
      instanceConfig: instanceConfig,
      params: params,
    );

    return FunctionResult(
      data: resultTransformer.transform(
        rawResponse: serverConnectResponse,
        requestType: URLRequest.function,
      ),
      success: true,
    );
  }

  /// Once a document has been created, it should be possible to create a unique id for it
  /// from its data, but the manner of doing so is implementation specific.
  @override
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return const DocumentId(documentClass: 'unknown', objectId: 'unknown');
  }

  /// TODO: This is a bit confused - what do we really need? https://gitlab.com/takkan/takkan_backend/-/issues/25
  /// Combines variable values from 3 possible sources. Order of precedence is:
  ///
  /// 1. [DataSelector.variables]
  /// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
  /// 1. Values passed as [pageArguments]
  @protected
  Map<String, dynamic> combineVariables(
      DataSelector selector, Map<String, dynamic> pageArguments) {
    final variables = <String, dynamic>{};
    // final propertyVariables = _buildPropertyVariables(selector.propertyReferences);
    variables.addAll(pageArguments);
    // variables.addAll(propertyVariables);
    // variables.addAll(selector.params);
    return variables;
  }

  // TODO: get variable values from property references

  @override
  Future<Script> latestScript(
      {required String locale,
      required int fromVersion,
      Delegate? useDelegate,
      required String name}) async {
    throw UnimplementedError();
  }

  @override
  String get sessionTokenKey => 'X-Parse-Session-Token';

  /// The property name for the field which provides a document's unique id
  @override
  String get objectIdKey => 'objectId';

  @override
  Future<ReadResult<dynamic>> executeGraphQL({
    required String script,
    FetchPolicy? fetchPolicy,
    FieldSelector? fieldSelector,
  }) {
    throw UnimplementedError();
  }
}

class GenericDataProvider extends BaseDataProvider<DataProvider, TakkanUser> {
  GenericDataProvider() : super();
}
