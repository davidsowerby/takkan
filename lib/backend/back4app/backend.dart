import 'package:precept_back4app_backend/backend/back4app/keyLoader.dart';
import 'package:precept_back4app_backend/backend/back4app/pBack4AppBackend.dart';
import 'package:precept_backend/backend/backendLibrary.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/backend.dart';
import 'package:precept_backend/backend/query/query.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:sembast/sembast_memory.dart';

class Back4AppBackend extends Backend<PBack4AppBackend> {
  Parse _parse;
  CoreStore _coreStore;

  Back4AppBackend(PBack4AppBackend config) : super(config: config);

  /// Can be called when already connected - it just returns without doing anything
  /// autoSendSessionId set to true as it is required for authentication and ACL
  doConnect() async {
    final ParseServerConfig serverConfig = await Back4AppKeyLoader().load(config.env);
    await _configureCoreStore(config.env);
    _parse = await Parse().initialize(
      serverConfig.appId,
      serverConfig.serverUrl,
      autoSendSessionId: true,
      debug: config.debug,
      coreStore: _coreStore,
      clientKey: serverConfig.clientId,
    );
    if (config.checkHealthOnConnect) {
      await healthCheck();
    }
return true; // TODO: What are the errors that need to be trapped?
  }

  @override
  Future<CloudResponse> delete({List<DocumentId> documentIds}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> executeFunction({String functionName, Map<String, dynamic> params}) async {
    final ParseCloudFunction function = ParseCloudFunction(functionName);
    final result = await function.execute(parameters: params);
    if (result.success) {
      return _convertResponse(result);
    } else {
      throw APIException(statusCode: result.statusCode, message: result.error.message);
    }
  }

  @override
  Future<bool> exists({DocumentId documentId}) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<Data> fetch({String functionName, DocumentId documentId}) {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<Data> fetchDistinct({String functionName, Map<String, dynamic> params}) {
    // TODO: implement fetchDistinct
    throw UnimplementedError();
  }

  @override
  Future<Data> getDistinct({Query query}) {
    // TODO: implement getDistinct
    throw UnimplementedError();
  }

  @override
  Stream<Data> getDistinctStream({Query query}) {
    // TODO: implement getDistinctStream
    throw UnimplementedError();
  }

  @override
  Future<Data> getList({Query query}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Stream<List<Data>> getListStream({Query query}) {
    // TODO: implement getListStream
    throw UnimplementedError();
  }

  @override
  Stream<Data> getStream({DocumentId documentId}) {
    // TODO: implement getStream
    throw UnimplementedError();
  }

  CloudResponse _convertResponse(ParseResponse original) {
    if (original.results != null) {
      return CloudResponse(result: original.results, success: original.success);
    }
    if (original.result != null) {
      return CloudResponse(result: original.result, success: original.success);
    }
    throw APIException(message: "No results returned");
  }

  @override
  Future<List<Data>> fetchList({functionName, Map<String, String> params}) {
    // TODO: implement fetchList
    throw UnimplementedError();
  }

  @override
  Future<Data> get({PDataGet query}) async {
    ParseResponse response =
        await ParseObject(query.documentId.path).getObject(query.documentId.itemId);
    if (response.success) {
      final result = response.results.first;
      return Data(data: result);
    } else {
      throw APIException(message: 'Failed to get data', statusCode: response.statusCode);
    }
  }

  @override
  Future<CloudResponse> save(
      {DocumentId documentId,
      Map<String, dynamic> changedData,
      Map<String, dynamic> fullData,
      DocumentType documentType = DocumentType.standard,
      bool saveChangesOnly = true,
      Function() onSuccess}) {
    // TODO: implement save
    throw UnimplementedError();
  }

  static register() {
    backendLibrary.register(config: PBack4AppBackend, builder: (config) => Back4AppBackend(config));
  }

  _configureCoreStore(Env env) async {
    _coreStore = (env == Env.prod)
        ? await CoreStoreSembastImp.getInstance('sembast')
        : await CoreStoreSembastImp.getInstance('sembast', factory: databaseFactoryMemory);
  }

  healthCheck() async {
    final health = await _parse.healthCheck();
    // final response = _convertResponse(health);
    logType(this.runtimeType).i('Parse health check status code: ${health.statusCode}');
  }
}
