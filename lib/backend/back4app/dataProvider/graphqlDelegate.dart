import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/fieldSelector.dart';
import 'package:precept_backend/backend/dataProvider/graphqlDelegate.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/util/string.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

class Back4AppGraphQLDelegate extends DefaultGraphQLDataProviderDelegate {
  Back4AppGraphQLDelegate(DataProvider parent) : super(parent);

  /// Creates a database row containing [script] and it associated fields.  Set [incrementVersion]
  /// to increment the version before saving
  /// 'nameLocale' value is created to use as a filter, combining script name and Locale
  Future<UpdateResult> uploadPreceptScript({
    required PScript script,
    required Locale locale,
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
          document: gql(createPreceptScriptMutation), variables: value),
    );
    if (queryResult.hasException) {
      throw APIException(
          message: queryResult.exception.toString(), statusCode: -1);
    }
    return UpdateResult(
      data: queryResult.data ?? {},
      success: true,
      path: 'PreceptScript',
    );
  }

  /// returns the latest script of the given [name] and [locale].  [fromVersion] helps to reduce
  /// the amount of data returned, but can otherwise always be 0.
  ///
  /// If somehow there are 2 or more instances with the same version, the most recently
  /// updated entry (using the 'updatedAt' field) is returned
  @override
  Future<ReadResult> latestScript(
      {required Locale locale,
      required int fromVersion,
      required String name}) async {
    final variables = {
      'locale': locale.toString(),
      'target': fromVersion,
      'nameLocale': '$name:${locale.toString()}'
    };
    List<Map<String, dynamic>> result = await fetchList(
      PGraphQLQuery(querySchema: 'laterScripts', script: laterScripts),
      variables,
    );

    if (result.isEmpty) {
      throw APIException(
          message: "Expected at least one Script", statusCode: -1);
    }

    Map<String, dynamic>? candidate;
    int count = 0;

    result.forEach((element) {
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

    return ReadResult(
      data: candidate!['script'],
      success: true,
      path: 'PreceptScript',
    );
  }

  @override
  Future<Authenticator<PDataProvider, ParseUser>> createAuthenticator() async {
    final auth = Back4AppAuthenticator(
      parent: parent as Back4AppDataProvider,
    );
    await auth.init();
    return auth;
  }

  @override
  Future<ReadResult> readDocument({
    required DocumentId documentId,
    FieldSelector fieldSelector = const FieldSelector(),
  }) async {
    final PDocument? schema = parent.config.schema.documents[documentId.path];
    if (schema == null) {
      throw PreceptException(
          'No schema has been defined for document: ${documentId.path}');
    }
    final queryOptions = QueryOptions(
        document: gql(_buildReadGQL(documentId, fieldSelector, schema)),
        variables: const {});
    final QueryResult response = await client.query(queryOptions);
    final String method = decapitalize(documentId.path);
    final Map<String, dynamic> data = response.data![method];
    data.remove('__typename');
    return ReadResult(
      success: false,
      data: data,
      path: documentId.path,
    );
  }
}

String createPreceptScriptMutation = '''
      mutation CreatePreceptScript(\$input: CreatePreceptScriptFieldsInput){
        createPreceptScript(input: {fields: \$input}){
          preceptScript{
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
  preceptScripts(where: { version: {greaterThanOrEqualTo: $target} AND: {nameLocale:{equalTo:$nameLocale}}    }) {
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

String _buildReadGQL(
    DocumentId documentId, FieldSelector fieldSelector, PDocument schema) {
  StringBuffer buf = StringBuffer('query Get${documentId.path} {');
  final decapPath = decapitalize(documentId.path);
  buf.writeln('$decapPath(id: \"${documentId.itemId}\") {');
  final fields = fieldSelector.selection(schema);
  if (!fields.contains('objectId')) {
    fields.add('objectId');
  }
  for (String field in fields) {
    buf.writeln('  $field');
  }
  buf.writeln('}');
  buf.writeln('}');
  return buf.toString();
}

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
