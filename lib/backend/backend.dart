import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/query/query.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/documentId.dart';

/// The layer between the client and server.
///
/// It provides a common authentication and data access interface regardless of the backend employed.
/// Most of the work is actually done in backend-specific implementations.
///
/// Some calls may not be supported by an implementation, in which case it will throw a [APINotSupportedException]
abstract class Backend<CONFIG extends PBackend> {
  final CONFIG config;
  BackendConnectionState _connectionState = BackendConnectionState.idle;
  final List<Function(BackendConnectionState)> _listeners = List();

  Backend({@required this.config});

  /// ================================================================================================
  /// All 'getXXX' methods use the standard 'database' access of a typical backend SDK
  /// For methods accessing Cloud Functions, use the 'fetchXXXX' methods
  /// ================================================================================================

  /// Returns a single instance of [Data] identified by [documentId]
  ///
  /// Throws an [APIException] if not found
  Future<Data> get({@required PDataGet query});

  /// Returns a Stream of [Data] identified by [documentId]
  ///
  /// Throws an [APIException] if not found
  Stream<Data> getStream({@required DocumentId documentId});

  /// Returns a list of [Data] instances for the document selected by [query]
  ///
  /// May return an empty list
  /// Throws an [APIException] if the query is not valid
  Future<Data> getList({@required Query query});

  /// Returns a Stream of List<Data> instances for the document selected by [query]
  ///
  /// May return an empty list
  /// throws an [APIException] if the query is not valid
  Stream<List<Data>> getListStream({@required Query query});

  /// Returns a single instance of [Data] for the [query]
  ///
  /// Throws an [APIException] if the result is not exactly one instance
  Future<Data> getDistinct({@required Query query});

  /// Returns a single instance of [Data] for the [query]
  ///
  /// Throws an [APIException] if the result is not exactly one instance
  Stream<Data> getDistinctStream({@required Query query});

  /// ================================================================================================
  /// All 'fetchXXX' methods call Cloud Functions
  /// To access the standard 'database' access of a typical backend SDK, use the 'getXXXX' methods
  /// Note there are no Streams returned by these calls
  /// ================================================================================================

  /// Returns a single instance of [Data] identified by [documentId], from a CloudFunction
  ///
  /// Throws an [APIException] if not found
  Future<Data> fetch({@required String functionName, @required DocumentId documentId});

  /// Returns a single instance of [Data] from a Cloud Function.
  ///
  ///
  /// Throws an [APIException] if the result is not exactly one instance, or the function call fails
  Future<Data> fetchDistinct({@required String functionName, Map<String, dynamic> params});

  /// Returns a list of [Data] instances by the cloud function [functionName] when executed wth [params]
  ///
  /// May return an empty list
  /// Throws an APIException if the function call fails
  Future<List<Data>> fetchList({@required functionName, Map<String, String> params});

  /// ================================================================================================
  /// Other calls
  /// ================================================================================================

  /// Returns true if the document exists, false otherwise
  Future<bool> exists({@required DocumentId documentId});

  /// Invokes a Cloud Function
  ///
  /// The result is determined by the Cloud Function, and is return in the [CloudResponse.result]
  Future<CloudResponse> executeFunction(
      {@required String functionName, Map<String, dynamic> params});

  /// Saves a document to the backend database.
  ///
  /// If [saveChangesOnly] is true (the default) only changed properties are passed to the backend.
  ///
  ///
  /// [documentId] is only required if [script] does not contain a valid [documentId], or this is to be saved to a document
  /// different to the one from which the data was taken.  If [documentId] is provided, it takes precedence over that
  /// within the model, effectively making this a "save as" call.
  ///
  /// [documentType] affects the meta data applied to the document - not yet implemented
  ///
  /// [script] contains the data to be saved
  ///
  Future<CloudResponse> save({
    DocumentId documentId,
    @required Map<String, dynamic> changedData,
    @required Map<String, dynamic> fullData,
    DocumentType documentType = DocumentType.standard,
    bool saveChangesOnly = true,
    Function() onSuccess,
  });

  /// Deletes one or more documents from persistence.
  ///
  /// Nothing happens if the document does not exist
  /// The [CloudResponse.success] will be false, and [CloudResponse.errorMessage] will be set if other failures occur,
  /// for example lack of permissions.
  Future<CloudResponse> delete({@required List<DocumentId> documentIds});

  _connecting() {
    _connectionState = BackendConnectionState.connecting;
    _fireListeners();
  }

  _connected() {
    _connectionState = BackendConnectionState.connected;
    _fireListeners();
  }

  _reset() {
    _connectionState = BackendConnectionState.idle;
    _fireListeners();
  }

  BackendConnectionState get connectionState => _connectionState;

  bool get isConnected => _connectionState == BackendConnectionState.connected;

  /// Add a listener to be notified when [connectionState] changes
  addListener(Function(BackendConnectionState) listener) {
    _listeners.add(listener);
  }

  removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  _fireListeners() {
    for (Function(BackendConnectionState) listener in _listeners) {
      listener(connectionState);
    }
  }

  /// Connects the backend, with implementation specific actions provided by [doConnect]
  /// Simply returns true if already connected.
  Future<bool> connect() async {
    // if (connectionState==BackendConnectionState.connecting || connectionState==BackendConnectionState.connected){
    //   return true;
    // }
    if (isConnected){
      return true;
    }
    _connecting();
    final connectionSuccess = await doConnect();
    if (connectionSuccess) {
      _connected();
    } else {
      _reset();
    }
    return connectionSuccess;
  }

  Future<bool> doConnect();

  void fail() {
    _connectionState = BackendConnectionState.failed;
    _fireListeners();
  }

  void reset() {
    _connectionState = BackendConnectionState.idle;
    _fireListeners();
  }
}


