import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/script/script.dart';

class Back4AppDataProvider extends DataProvider<PBack4AppDataProvider> {
  Back4AppDataProvider({required PBack4AppDataProvider config}) : super(config: config);

  @override
  Authenticator<PBack4AppDataProvider, ParseUser> createAuthenticator(
          PBack4AppDataProvider config) =>
      Back4AppAuthenticator(parent: this, config: config);

  @override
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(path: data['__typename'], itemId: data['objectId']);
  }

  @override
  String get sessionTokenKey => 'X-Parse-Session-Token';

  /// Creates a database row containing [script] and it associated fields.  Set [incrementVersion]
  /// to increment the version before saving
  Future<QueryResult> uploadPreceptScript({
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
    final String nameLocale= '${script.name}:${locale.toString()}';

    final Map<String, dynamic> value = {
      'input': {
        'name': script.name,
        'locale': locale.toString(),
        'script': scriptJson,
        'version': version,
        'nameLocale':nameLocale,
      },
    };
    QueryResult queryResult = await client.query(
      QueryOptions(document: gql(createPreceptScriptMutation), variables: value),
    );
    return queryResult;
  }

  /// returns the latest script of the given [name] and [locale].  [fromVersion] helps to reduce
  /// the amount of data returned, but can otherwise always be 0.
  ///
  /// If somehow there are 2 or more instances with the same version, the most recently
  /// updated entry (using the 'updatedAt' field) is returned
  @override
  Future<PScript> latestScript(
      {required Locale locale, required int fromVersion, required String name}) async {
    final variables = {
      'locale': locale.toString(),
      'target': fromVersion,
      'nameLocale': '$name:${locale.toString()}'
    };
    List<Map<String, dynamic>> result = await gQueryList(
        query: PGQuery(
      name: 'laterScripts',
      table: 'PreceptScript',
      script: laterScripts,
      variables: variables,
    ));

    if (result.isEmpty) {
      throw APIException(message: "Expected at least one Script", statusCode: -1);
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
            candidate=element;
          }
        }
      }
    count++;});

    return PScript.fromJson(candidate!['script']);
  }
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        config: PBack4AppDataProvider,
        builder: (config) => Back4AppDataProvider(config: config as PBack4AppDataProvider));
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

String laterScripts = r'''query LaterScripts ($target: Float!, $nameLocale: String!){
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
