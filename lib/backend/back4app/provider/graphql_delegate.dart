import 'package:graphql/client.dart';
import 'package:takkan_backend/backend/data_provider/graphql_delegate.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_backend/backend/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/util/string.dart';

class Back4AppGraphQLDelegate extends DefaultGraphQLDataProviderDelegate {
  Back4AppGraphQLDelegate() : super();

  /// Creates a database row containing [script] and it associated fields.  Set [incrementVersion]
  /// to increment the version before saving
  /// 'nameLocale' value is created to use as a filter, combining script name and Locale
  Future<UpdateResult> uploadTakkanScript({
    required Script script,
    required String locale,
    bool incrementVersion = false,
  }) async {
    final Map<String, dynamic> scriptJson = script.toJson();
    int version = scriptJson['version'] as int;
    if (incrementVersion) {
      version++;
      scriptJson['version'] = version;
    }
    final String nameLocale = '${script.name}:${locale.toString()}';

    final Map<String, dynamic> value = {
      'input': {
        'name': script.name,
        'locale': locale.toString(),
        'script': scriptJson,
        'version': version,
        'nameLocale': nameLocale,
      },
    };
    QueryResult queryResult = await client.query(
      QueryOptions(
          document: gql(createTakkanScriptMutation), variables: value),
    );
    if (queryResult.hasException) {
      throw APIException(
          message: queryResult.exception.toString(), statusCode: -1);
    }
    return UpdateResult(
      data: queryResult.data ?? {},
      success: true,
      documentClass: 'TakkanScript',
      objectId: '??',
    );
  }

  /// returns the latest script of the given [name] and [locale].  [fromVersion] helps to reduce
  /// the amount of data returned, but can otherwise always be 0.
  ///
  /// If somehow there are 2 or more instances with the same version, the most recently
  /// updated entry (using the 'updatedAt' field) is returned
  @override
  Future<ReadResultItem> latestScript(
      {required String locale,
      required int fromVersion,
      required String name}) async {
    final variables = {
      'locale': locale.toString(),
      'target': fromVersion,
      'nameLocale': '$name:${locale.toString()}'
    };
    ReadResultList result = await fetchList(
      GraphQLQuery(
          queryName: 'laterScripts',
          queryScript: laterScripts,
          documentSchema: 'PScript'),
      variables,
    );

    if (result.isEmpty) {
      throw APIException(
          message: "Expected at least one Script", statusCode: -1);
    }

    Map<String, dynamic>? candidate;
    int count = 0;

    result.data.forEach((element) {
      if (count == 0) {
        candidate = element;
      } else {
        if (element['version'] > candidate?['version']) {
          candidate = element;
        } else {
          if ((element['version'] > candidate?['version']) &&
              (element['updatedAt'] > candidate?['updatedAt'])) {
            candidate = element;
          }
        }
      }
      count++;
    });

    return ReadResultItem(
      data: candidate!['script'],
      success: true,
      documentClass: 'TakkanScript',
      queryReturnType: QueryReturnType.futureItem,
    );
  }

  // @override
  // Future<ReadResultItem> readDocument({
  //   required DocumentId documentId,
  //   FieldSelector fieldSelector = const FieldSelector(),
  //   FetchPolicy? fetchPolicy,
  // }) async {
  //   final PDocument schema =
  //       parent.documentSchema(documentSchemaName: documentId.documentClass);
  //   final builder = GraphQLScriptBuilder();
  //   final script = builder.buildReadGQL(documentId, fieldSelector, schema);
  //   final queryOptions = QueryOptions(
  //     document: gql(script),
  //     variables: {'id': documentId.objectId},
  //     fetchPolicy: fetchPolicy,
  //   );
  //   final QueryResult response = await client.query(queryOptions);
  //   final Map<String, dynamic> data = response.data?[builder.selectionSet];
  //   data.remove('__typename');
  //   return ReadResultItem(
  //     success: false,
  //     data: data,
  //     documentClass: documentId.documentClass,
  //     queryReturnType: QueryReturnType.futureItem,
  //   );
  // }

  // @override
  // assembleScript(
  //     PGraphQLQuery queryConfig, Map<String, dynamic> pageArguments) {
  //   // TODO: implement assembleScript
  //   throw UnimplementedError();
  // }

  // @override
  // Future<CreateResult> createDocument({
  //   required String documentClass,
  //   required Map<String, dynamic> data,
  //   required String documentIdKey,
  //   FieldSelector fieldSelector = const FieldSelector(),
  // }) async {
  //   final PDocument schema =
  //       parent.documentSchema(documentSchemaName: documentClass);
  //   final GraphQLScriptBuilder builder = GraphQLScriptBuilder();
  //   final script = builder.buildCreateGQL(documentClass, fieldSelector, schema);
  //   final strippedData = Map<String, dynamic>.from(data);
  //   strippedData.remove('id');
  //   strippedData.remove('objectId');
  //   final Map<String, dynamic> input = {'input': strippedData};
  //
  //   QueryResult queryResult = await _executeQuery(script, input);
  //   if (queryResult.hasException) {
  //     throw APIException(
  //         message: queryResult.exception.toString(), statusCode: -1);
  //   }
  //   final Map<String, dynamic> returnedData =
  //       queryResult.data![builder.methodName][builder.selectionSet];
  //   return CreateResult(
  //     data: returnedData,
  //     success: true,
  //     documentClass: documentClass,
  //     objectId: returnedData['objectId'],
  //   );
  // }

  // @override
  // Future<UpdateResult> updateDocument({
  //   required DocumentId documentId,
  //   FieldSelector fieldSelector = const FieldSelector(),
  //   required Map<String, dynamic> data,
  // }) async {
  //   final PDocument schema =
  //       parent.documentSchema(documentSchemaName: documentId.documentClass);
  //   final GraphQLScriptBuilder builder = GraphQLScriptBuilder();
  //   final script = builder.buildUpdateGQL(documentId, fieldSelector, schema);
  //
  //   data.remove('objectId');
  //   final Map<String, dynamic> input = {
  //     'input': {'id': documentId.objectId, 'fields': data}
  //   };
  //   QueryResult queryResult = await _executeQuery(script, input);
  //   final Map<String, dynamic> returnedData =
  //       queryResult.data![builder.methodName][builder.selectionSet];
  //   returnedData.remove('__typename');
  //   return UpdateResult(
  //     success: true,
  //     documentClass: documentId.documentClass,
  //     data: returnedData,
  //     objectId: documentId.objectId,
  //   );
  // }

  Future<QueryResult> _executeQuery(
      String script, Map<String, dynamic> variables,
      [FetchPolicy? fetchPolicy]) async {
    QueryResult queryResult = await client.query(
      QueryOptions(
          document: gql(script),
          variables: variables,
          fetchPolicy: fetchPolicy),
    );
    if (queryResult.hasException) {
      String msg = queryResult.exception.toString();
      logType(this.runtimeType).e(msg);
      throw APIException(message: msg, statusCode: -1);
    }
    return queryResult;
  }

// @override
// Future<DeleteResult> deleteDocument({required DocumentId documentId}) {
//   // TODO: implement deleteDocument
//   throw UnimplementedError();
// }
//
// @override
// Future<Map<String, dynamic>> fetchItem(
//     PGraphQLQuery queryConfig, Map<String, dynamic> variables) {
//   // TODO: implement fetchItem
//   throw UnimplementedError();
// }
//
// @override
// Future<List<Map<String, dynamic>>> fetchList(
//     PGraphQLQuery queryConfig, Map<String, dynamic> variables) {
//   // TODO: implement fetchList
//   throw UnimplementedError();
// }
//
//
// @override
// setSessionToken(String token) {
//   // TODO: implement setSessionToken
//   throw UnimplementedError();
// }
//

}

String createTakkanScriptMutation = '''
      mutation CreateTakkanScript(\$input: CreateTakkanScriptFieldsInput){
        createTakkanScript(input: {fields: \$input}){
          takkanScript{
            name,
            locale,
            script,
            version,
            nameLocale
          }
        }
      }
      ''';

String laterScripts =
    r'''query LaterScripts ($target: Float!, $nameLocale: String!){
  takkanScripts(where: { version: {greaterThanOrEqualTo: $target} AND: {nameLocale:{equalTo:$nameLocale}}    }) {
    count
    edges {
      node {
        objectId
        id
        name
        version
        locale
        nameLocale
        script
        updatedAt
      }
    }
  }
}''';

//   Future<Map<String, dynamic>> pQuery(
//       {required PPQuery query, Map<String, dynamic> pageArguments = const {}}) async {
//     final Map<String, dynamic> variables = combineVariables(query, pageArguments);
//     final StringBuffer buf = StringBuffer();
//     buf.write('query Get');
//     buf.write(query.table);
//     buf.write('(');
//     bool first = true;
//     for (MapEntry<String, String> entry in query.types.entries) {
//       if (!first) {
//         buf.write(',');
//       } else {
//         first = false;
//       }
//       buf.write(' \$${entry.key}: ${entry.value}');
//     }
//     buf.write(') {');
//     buf.write(decapitalize(query.table));
//     buf.write('(');
//     first = true;
//     for (MapEntry<String, dynamic> entry in variables.entries) {
//       if (!first) {
//         buf.write(',');
//       } else {
//         first = false;
//       }
//       buf.write('${entry.key}: \$${entry.key}');
//     }
//     buf.write(') {');
//     buf.write(query.fields);
//     buf.write('}}');
//     return _query(query: query, script: buf.toString(), pageArguments: pageArguments);
//   }

class GraphQLScriptBuilder {
  String? methodName;
  String? selectionSet;

  String buildCreateGQL(
    String path,
    FieldSelector fieldSelector,
    Document schema,
  ) {
    StringBuffer buf = StringBuffer();
    buf.writeln('mutation Create$path(\$input: Create${path}FieldsInput){');
    methodName = 'create$path';
    buf.writeln('  $methodName(input: {fields: \$input}){');
    selectionSet = decapitalize(path);
    buf.writeln('    $selectionSet{');
    addFields(buf, fieldSelector, schema, 'objectId');
    buf.writeln('}');
    buf.writeln('}');
    buf.write('}');
    return buf.toString();
  }

  String buildReadGQL(
    DocumentId documentId,
    FieldSelector fieldSelector,
    Document schema,
  ) {
    StringBuffer buf = StringBuffer();
    buf.writeln('query Get${documentId.documentClass}(\$id:ID!) {');
    selectionSet = decapitalize(documentId.documentClass);
    methodName = selectionSet;
    buf.writeln('$selectionSet(id: \$id) {');
    addFields(buf, fieldSelector, schema, '');
    buf.writeln('}');
    buf.write('}');
    return buf.toString();
  }

  String buildUpdateGQL(
    DocumentId documentId,
    FieldSelector fieldSelector,
    Document schema,
  ) {
    StringBuffer buf = StringBuffer();
    buf.writeln(
        'mutation Update${documentId.documentClass} (\$input: Update${documentId.documentClass}Input!){');
    selectionSet = decapitalize(documentId.documentClass);
    methodName = 'update${documentId.documentClass}';
    buf.writeln('$methodName(input: \$input){');
    buf.writeln('$selectionSet{');
    addFields(buf, fieldSelector, schema, 'updatedAt');
    buf.writeln('}');
    buf.writeln('}');
    buf.write('}');
    return buf.toString();
  }

  addFields(StringBuffer buf, FieldSelector fieldSelector, Document schema,
      String defaultSelection) {
    final fields = fieldSelector.selection(schema);
    if (defaultSelection.isNotEmpty) {
      if (!fields.contains(defaultSelection)) {
        fields.insert(0, defaultSelection);
      }
    }
    for (String field in fields) {
      buf.writeln('      $field');
    }
  }
}
