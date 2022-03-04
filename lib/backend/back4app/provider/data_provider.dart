import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:precept_back4app_client/backend/back4app/authenticator/authenticator.dart';
import 'package:precept_back4app_client/backend/back4app/provider/graphql_delegate.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_backend/backend/data_provider/delegate.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/document_id.dart';

class Back4AppDataProvider extends DefaultDataProvider<PDataProvider> {
  Back4AppDataProvider({required PDataProvider config})
      : super(
          config: config,
        );

  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(path: data['__typename'], itemId: data['objectId']);
  }

  Future<Authenticator> createAuthenticator() async {
    return Back4AppAuthenticator();
  }

  GraphQLDataProviderDelegate createGraphQLDelegate() {
    return Back4AppGraphQLDelegate();
  }
}

class Back4App {
  static register() {
    dataProviderLibrary.register(
        type: 'back4app',
        builder: (config) => Back4AppDataProvider(config: config));
  }
}

Back4AppGraphQLDelegate constructGraphQLDelegate() {
  return Back4AppGraphQLDelegate();
}

Future<Authenticator<PDataProvider, ParseUser, Back4AppDataProvider>>
    constructAuthenticator() async {
  return Back4AppAuthenticator();
}

final allRolesScript = r'''
query AllRoles{
  roles{
    edges{
      node{
        name,
        objectId
      }
    }
  }
}
''';
