import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:takkan_back4app_client/backend/back4app/authenticator/authenticator.dart';
import 'package:takkan_back4app_client/backend/back4app/provider/graphql_delegate.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider_library.dart';
import 'package:takkan_backend/backend/data_provider/delegate.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/document_id.dart';

class Back4AppDataProvider extends DefaultDataProvider<DataProvider> {
  Back4AppDataProvider({required DataProvider config})
      : super(
    config: config,
  );

  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(
        documentClass: data['__typename'], objectId: data['objectId']);
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

Future<Authenticator<DataProvider, ParseUser, Back4AppDataProvider>>
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
