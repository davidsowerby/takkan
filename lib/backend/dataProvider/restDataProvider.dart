
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/data/provider/restDataProvider.dart';
import 'package:precept_script/query/restQuery.dart';

class RestDataProvider<CONFIG extends PRestDataProvider> extends DataProvider<CONFIG, PRestQuery> {
  RestDataProvider({required CONFIG config}) : super(config: config);

  static register() {
    dataProviderLibrary.register(
        configType: PRestDataProvider,
        builder: (config) => RestDataProvider(config: config as PRestDataProvider));
  }

  @override
  addSessionToken() {
    // TODO: implement addSessionToken
    throw UnimplementedError();
  }

  @override
  String assembleScript(PRestQuery queryConfig, Map<String, dynamic> pageArguments) {
    // TODO: implement assembleScript
    throw UnimplementedError();
  }

  @override
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    // TODO: implement documentIdFromData
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> executeQuery(String script, Map<String, dynamic> variables) {
    // TODO: implement executeQuery
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> executeQueryList(
      String table, String script, Map<String, dynamic> variables) {
    // TODO: implement executeQueryList
    throw UnimplementedError();
  }

  @override
  executeUpdate(
    String script,
    DocumentId documentId,
    Map<String, dynamic> changedData,
    DocumentType documentType,
  ) {
    // TODO: implement executeUpdate
    throw UnimplementedError();
  }

  @override
  Future<bool> updateDocument(
      {required DocumentId documentId,
      required Map<String, dynamic> changedData,
      DocumentType documentType = DocumentType.standard}) {
    // TODO: implement updateDocument
    throw UnimplementedError();
  }

  @override
  Authenticator<PDataProviderBase, dynamic> doCreateAuthenticator() {
    throw UnimplementedError(
        'If you need to authenticate, use a backend specific implementation of RestDataProvider');
  }
}
