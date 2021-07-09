import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_script/app/appConfig.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/restQuery.dart';

abstract class DataProviderDelegate<QUERY extends PQuery> {
  init(AppConfig appConfig);

  /// Executes a query expecting a single result
  Future<Map<String, dynamic>> fetchItem(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// Executes a query expecting 0..n results
  Future<List<Map<String, dynamic>>> fetchList(
      QUERY queryConfig, Map<String, dynamic> variables);

  /// Executes an update to a document
  Future<bool> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
  });

  setSessionToken(String token);

  assembleScript(QUERY queryConfig, Map<String, dynamic> pageArguments);

  Authenticator createAuthenticator();
}

/// Defined as an interface to enable injection of alternative implementations
abstract class RestDataProviderDelegate
    implements DataProviderDelegate<PRestQuery> {}

/// Defined as an interface to enable injection of alternative implementations
abstract class GraphQLDataProviderDelegate
    implements DataProviderDelegate<PGraphQLQuery> {}
