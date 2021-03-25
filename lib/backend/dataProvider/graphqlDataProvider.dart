
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/common/util/string.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/query.dart';

/// The GraphQL implementation of a [DataProvider]
class GraphQLDataProvider<T extends PGraphQLDataProvider> extends DataProvider<T> {
  GraphQLClient _client;

  GraphQLDataProvider({@required T config})
      : assert(config != null),
        super(config: config) {
    HttpLink _httpLink = HttpLink(
      config.endpoint,
      defaultHeaders: config.headers,
    );

    _client = GraphQLClient(
      /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: _httpLink,
    );
  }

  @override
  Future<CloudResponse> delete({List<DocumentId> documentIds}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> executeFunction({String functionName, Map<String, dynamic> params}) {
    // TODO: implement executeFunction
    throw UnimplementedError();
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
  Future<List<Data>> fetchList({functionName, Map<String, String> params}) {
    // TODO: implement fetchList
    throw UnimplementedError();
  }

  @override
  Future<Data> getDistinct({PQuery query, Map<String, dynamic> pageArguments = const {}}) async {
    throw UnimplementedError();
  }

  Future<Data> query(
      {PQuery query, String script, Map<String, dynamic> pageArguments = const {}}) async {
    return (query is PGQuery)
        ? gQuery(query: query, pageArguments: pageArguments)
        : pQuery(query: query, pageArguments: pageArguments);
  }

  Future<Data> gQuery({PGQuery query, Map<String, dynamic> pageArguments = const {}}) async {
    return _query(query: query, script: query.script, pageArguments: pageArguments);
  }

  Future<Data> _query(
      {PQuery query, String script, Map<String, dynamic> pageArguments = const {}}) async {
    final Map<String, dynamic> variables = _combineVariables(query, pageArguments);
    final queryOptions = QueryOptions(document: gql(script), variables: variables);
    final QueryResult response = await _client.query(queryOptions);
    final String method = decapitalize(query.table);
    final actualData = response.data[method];
    return Data(data: actualData, documentId: DocumentId(path: query.table, itemId: actualData['id']));
  }

  Future<Data> pQuery({PPQuery query, Map<String, dynamic> pageArguments = const {}}) async {
    final Map<String, dynamic> variables = _combineVariables(query, pageArguments);
    final StringBuffer buf = StringBuffer();
    buf.write('query Get');
    buf.write(query.table);
    buf.write('(');
    bool first = true;
    for (MapEntry<String, String> entry in query.types.entries) {
      if (!first) {
        buf.write(',');
      } else {
        first = false;
      }
      buf.write(' \$${entry.key}: ${entry.value}');
    }
    buf.write(') {');
    buf.write(decapitalize(query.table));
    buf.write('(');
    first = true;
    for (MapEntry<String, dynamic> entry in variables.entries) {
      if (!first) {
        buf.write(',');
      } else {
        first = false;
      }
      buf.write('${entry.key}: \$${entry.key}');
    }
    buf.write(') {');
    buf.write(query.fields);
    buf.write('}}');
    return _query(query: query, script: buf.toString(), pageArguments: pageArguments);
  }

  @override
  Future<Data> getDocument({@required DocumentId documentId}) async {
    final PPQuery q =
        PPQuery(table: documentId.path, variables: {'id': documentId.itemId}, types: {'id': 'ID!'});
    return pQuery(query: q);
  }

  Map<String, dynamic> _combineVariables(PQuery query, Map<String, dynamic> pageArguments) {
    assert(pageArguments!=null);
    final variables = Map<String, dynamic>();
    final propertyVariables = _buildPropertyVariables(query.propertyReferences);
    variables.addAll(pageArguments);
    variables.addAll(propertyVariables);
    variables.addAll(query.variables);
    return variables;
  }

  Map<String, dynamic> _buildPropertyVariables(List<String> propertyReferences) {
    return {};
  }

  @override
  Stream<Data> getDistinctStream({PQuery query}) {
    // TODO: implement getDistinctStream
    throw UnimplementedError();
  }

  @override
  Future<Data> getList({PQuery query}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Stream<List<Data>> getListStream({PQuery query}) {
    // TODO: implement getListStream
    throw UnimplementedError();
  }

  @override
  Stream<Data> getStream({@required PGet query, Map<String, dynamic> pageArguments = const {}}) {
    // TODO: implement getStream
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> save(
      {DocumentId documentId,
      Map<String, dynamic> fullData,
      DocumentType documentType = DocumentType.standard,
      Function() onSuccess}) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> create({
    DocumentId documentId,
    Map<String, dynamic> fullData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  }) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> update({
    DocumentId documentId,
    Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
    Function() onSuccess,
  }) async {
    // final Response response = await Dio(BaseOptions(headers: config.headers)).put(
    //   config.documentUrl(documentId),
    //   data: changedData,
    // );
    // if (response.statusCode == HttpStatus.ok) {
    //   return true;
    // }
    // throw APIException(message: response.statusMessage, statusCode: response.statusCode);
    // # Don't forget to set the OBJECT_ID parameter
    // curl -X PUT \
    // -H 'X-Parse-Application-Id: at4dM5dN0oCRryJp7VtTccIKZY9l3GtfHre0Hoow' \
    // -H 'X-Parse-REST-API-Key: Em49eaT0rrvEnL1tdH6F4TKyrObO3pNtEjwUAk1u' \
    // -H 'Content-Type: application/json' \
    // -d '{ \'category\': \'A string\',\'accountNumber\': \'A string\' }' \
    // https://parseapi.back4app.com/classes/Account/<OBJECT_ID>
  }

  @override
  Authenticator<T> createAuthenticator(T config) => throw UnimplementedError();
}
