import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';

class Back4AppDataProvider extends DataProvider<PBack4AppDataProvider> {
  Back4AppDataProvider({@required PBack4AppDataProvider config}) : super(config: config);

  @override
  Authenticator<PBack4AppDataProvider, ParseUser> createAuthenticator(
          PBack4AppDataProvider config) =>
      Back4AppAuthenticator(config: config);

  @override
  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(path: data['__typename'], itemId: data['objectId']);
  }

  @override
  Future<List<String>> userRoles() async {
    PGQuery query = PGQuery(
        name: 'userRoles',
        table: 'Role',
        script: userRolesScript,
        returnType: QueryReturnType.futureList,
        variables: {'id': authenticator.user.objectId});
    final Map<String, dynamic> result = await gQuery(query: query);
    print('results: ${result.length}');
    return List.empty();
  }

  @override
  String get sessionTokenKey => "X-Parse-Session-Token";
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        config: PBack4AppDataProvider, builder: (config) => Back4AppDataProvider(config: config));
  }
}

final userRolesScript = r'''query GetRoles  ($id: ID!) {
  roles (where: {users: {have: {id:{equalTo: $id}}}}){
    edges {
    node{name}
    }
    }

}''';
