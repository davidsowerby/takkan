import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/app/appConfig.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/query/query.dart';

/// The layer between the client and server.
///
/// It provides a consistent data access interface regardless of the type of data provider used.
///
/// An implementation could, for example, use GraphQL quereis but REST for updates, but that is transparent
/// to the app.
///
/// Sub-classes may change some elements of how the provider works. To achieve this, an implementation
/// must register a sub-class of this with calls to [DataProviderLibrary.register]
///
/// In addition to CRUD calls, this class also provides a backend-specific [Authenticator]
/// implementation, for use where a user is required to authenticate for a particular data provider.
/// The [Authenticator] also contains a [UserState] object for this data provider, holding
/// basic user information and authentication status.
///
/// If a call is not supported by an implementation, it will throw a [APINotSupportedException]
///
/// Note that the [DataProviderLibrary] acts as a cache. Multiple instances of the same DataProvider
/// class are identified by the [PConfigSource], but each such instance is effectively cached to ensure
/// consistency of state.
///
/// This means in theory, (as yet untested) that a client app could actually log in as a different
/// user for each [DataProvider] it uses.

abstract class DataProvider<CONFIG extends PDataProviderBase, QUERY extends PQuery> {
  CONFIG get config;

  Authenticator? _authenticator;

  AppConfig get appConfig;

  List<String> get userRoles;

  Authenticator get authenticator;

  PreceptUser get user;

  SignInStatus get authStatus;

  init(AppConfig appConfig);

  /// Returns a Future of a single instance of a document
  Future<Map<String, dynamic>> query({
    required QUERY queryConfig,
    required Map<String, dynamic> pageArguments,
  });

  /// Returns a Future of a list of one or more document instances
  Future<List<Map<String, dynamic>>> queryList({
    required QUERY queryConfig,
    required Map<String, dynamic> pageArguments,
  });

  Future<bool> updateDocument({
    required DocumentId documentId,
    required Map<String, dynamic> changedData,
    DocumentType documentType = DocumentType.standard,
  });

  createAuthenticator();

  /// Once a document has been created, it should be possible to create a unique id for it
  /// from its data, but the manner of doing so is implementation specific.
  DocumentId documentIdFromData(Map<String, dynamic> data);
}
