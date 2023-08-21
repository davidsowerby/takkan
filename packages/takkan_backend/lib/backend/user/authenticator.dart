import 'package:meta/meta.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/data/provider/data_provider.dart';

import '../data_provider/data_provider.dart';
import 'takkan_user.dart';

abstract class Authenticator<CONFIG extends DataProvider, USER> {
  Authenticator(this.parent);

  final IDataProvider<CONFIG> parent;
  final Set<String> _userRoles = {};

  final List<Function(SignInStatus)> _signInStatusListeners =
      List.empty(growable: true);
  SignInStatus _status = SignInStatus.Uninitialized;
  USER? nativeUser;

  TakkanUser get user => takkanUserFromNative(nativeUser);

  USER takkanUserToNative(TakkanUser takkanUser);

  TakkanUser takkanUserFromNative(USER? nativeUser);

  void addSignInStatusListener(Function(SignInStatus) listener) {
    _signInStatusListeners.add(listener);
  }

  void removeSignInStatusListener(Function(SignInStatus) listener) {
    _signInStatusListeners.remove(listener);
  }

  Future<bool> registerWithEmail(
      {required String username, required String password}) async {
    status = SignInStatus.Registering;
    final result =
        await doRegisterWithEmail(username: username, password: password);
    status = (result.success)
        ? SignInStatus.Registered
        : SignInStatus.Registration_Failed;
    return result.success;
  }

  /// Signs the user out.  Clears the [_signInStatusListeners], otherwise we could invoke a listener
  /// that has been disposed
  Future<bool> signOut() async {
    if (isAuthenticated) {
      await doSignOut();
      _signInStatusListeners.clear();
      status = SignInStatus.Unauthenticated;
      nativeUser = null;
      return true;
    } else {
      logType(runtimeType).i('already logged out');
      return false;
    }
  }

  bool get isAuthenticated => _status == SignInStatus.Authenticated;

  bool get isNotAuthenticated => !isAuthenticated;

  @protected
  Future<void> doSignOut();

  Future<AuthenticationResult> doRegisterWithEmail(
      {required String username, required String password});

// TODO: this needs to handle other failures (lost connections etc)
  Future<AuthenticationResult> signInByEmail(
      {required String username, required String password}) async {
    if (status == SignInStatus.Uninitialized) {
      await init();
    }
    status = SignInStatus.Authenticating;
    final AuthenticationResult result =
        await doSignInByEmail(username: username, password: password);
    if (result.success) {
      status = SignInStatus.Authenticated;
      await _loadUserRoles();
      return result;
    } else {
      status = SignInStatus.Authentication_Failed;
      return result;
    }
  }

  Future<void> _loadUserRoles() async {
    final List<String> roles = await loadUserRoles();
    _userRoles.addAll(roles);
  }

  Future<List<String>> loadUserRoles();

  /// Must set [UserState.sessionToken]
  Future<AuthenticationResult> doSignInByEmail(
      {required String username, required String password});

  Future<bool> requestPasswordReset(TakkanUser user) async {
    throw UnimplementedError();
  }

  Future<bool> doRequestPasswordReset(TakkanUser user);

  /// Really just a data update for user details, but the implementation will have defined how to
  /// access user information (which may in some case actually two user 'tables', depending on the
  /// backend implementation so we need to use this rather than a more general interface
  Future<bool> updateUser(TakkanUser user) async {
    return doUpdateUser(user);
  }

  Future<bool> doUpdateUser(TakkanUser user);

  Future<bool> deRegister(TakkanUser user) async {
    status = SignInStatus.Removing_Registration;
    final result = await doDeRegister(user);
    status = result
        ? status = SignInStatus.Registration_Removed
        : SignInStatus.Uninitialized;
    return result;
  }

  Future<bool> doDeRegister(TakkanUser user);

  /// Not sure what this is need for :-)
  void registrationAcknowledged() {}

  /// Implementation specific.Some Authenticators may not need initialisation, but
  /// must always set status to [SignInStatus.Initialised]
  @mustCallSuper
  Future<SignInStatus> init() async {
    status = SignInStatus.Initialised;
    return status;
  }

  SignInStatus get status => _status;

  set status(SignInStatus value) {
    _status = value;
    notifyStatusListeners();
  }

  Set<String> get userRoles => _userRoles;

  void notifyStatusListeners() {
    for (final element in _signInStatusListeners) {
      element(status);
    }
  }
}

enum SignInStatus {
  Uninitialized,
  Initialised,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Authentication_Failed,
  Removing_Registration,
  Reset_Requested,
  Registering,
  Registered,
  Registration_Failed,
  Registration_Removed,
  User_Not_Known,
}

/// - [success] if true, authentication successful. If true, [errorCode] and [message] fields are irrelevant
/// - [user] A successful authentication may return additional user information
/// - [errorCode] if not -1, represents some kind of failure, perhaps a lost connection for example.  See https://gitlab.com/takkan/takkan_backend/-/issues/1
/// - [message] currently this is implementation specific - see https://gitlab.com/takkan/takkan_backend/-/issues/1
class AuthenticationResult {
  // TODO standardise for all implementations
  AuthenticationResult({
    required this.success,
    required this.user,
    this.errorCode = -999,
    this.message = 'Unknown',
  });

  final TakkanUser user;
  final bool success;
  final int errorCode;
  final String message;
}
