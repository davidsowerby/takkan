import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';

import 'file:///home/david/git/precept/precept_client/lib/user/userState.dart';

abstract class Authenticator<T extends PDataProviderBase, USER> {
  final List<String> _userRoles = List.empty(growable: true);
  final List<Function(SignInStatus)> _signInStatusListeners = List.empty(growable: true);
  SignInStatus _status = SignInStatus.Uninitialized;
  USER? nativeUser;

  PreceptUser get user => preceptUserFromNative(nativeUser);

  USER preceptUserToNative(PreceptUser preceptUser);

  PreceptUser preceptUserFromNative(USER? nativeUser);

  addSignInStatusListener(Function(SignInStatus) listener) {
    _signInStatusListeners.add(listener);
  }

  removeSignInStatusListener(Function(SignInStatus) listener) {
    _signInStatusListeners.remove(listener);
  }

  Future<bool> registerWithEmail({required String username, required String password}) async {
    status = SignInStatus.Registering;
    final result = await doRegisterWithEmail(username: username, password: password);
    status = (result.success) ? SignInStatus.Registered : SignInStatus.Registration_Failed;
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
      logType(this.runtimeType).i("already logged out");
      return false;
    }
  }

  bool get isAuthenticated => _status == SignInStatus.Authenticated;

  @protected
  doSignOut();

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

  _loadUserRoles() async {
    final List<String> roles = await loadUserRoles();
    _userRoles.addAll(roles);
  }

  Future<List<String>> loadUserRoles();

  /// Must set [UserState.sessionToken]
  Future<AuthenticationResult> doSignInByEmail(
      {required String username, required String password});

  Future<bool> requestPasswordReset(PreceptUser user) async {
    throw UnimplementedError();
  }

  Future<bool> doRequestPasswordReset(PreceptUser user);

  /// Really just a data update for user details, but the implementation will have defined how to
  /// access user information (which may in some case actually two user 'tables', depending on the
  /// backend implementation so we need to use this rather than a more general interface
  Future<bool> updateUser(PreceptUser user) async {
    return await doUpdateUser(user);
  }

  Future<bool> doUpdateUser(PreceptUser user);

  Future<bool> deRegister(PreceptUser user) async {
    status = SignInStatus.Removing_Registration;
    final result = await doDeRegister(user);
    status = (result) ? status = SignInStatus.Registration_Removed : SignInStatus.Uninitialized;
    return result;
  }

  Future<bool> doDeRegister(PreceptUser user);

  /// Not sure what this is need for :-)
  registrationAcknowledged() {}

  /// Implementation specific, may not be needed, but must always change status to [SignInStatus.Initialised]
  init(){
    status=SignInStatus.Initialised;
  }

  SignInStatus get status => _status;

  set status(value) {
    _status = value;
    notifyStatusListeners();
  }

  List<String> get userRoles => _userRoles;

  notifyStatusListeners() {
    _signInStatusListeners.forEach((element) {
      element(status);
    });
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
/// - [errorCode] if not -1, represents some kind of failure, perhaps a lost connection for example.  See https://gitlab.com/precept1/precept_backend/-/issues/1
/// - [message] currently this is implementation specific - see https://gitlab.com/precept1/precept_backend/-/issues/1
class AuthenticationResult {
  final PreceptUser user;
  final bool success;
  final int errorCode;
  final String message;

  // TODO standardise for all implementations
  AuthenticationResult({
    required this.success,
    required this.user,
    this.errorCode = -999,
    this.message = 'Unknown',
  });
}
