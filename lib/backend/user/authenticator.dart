import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_backend/backend/user/userState.dart';
import 'package:precept_script/data/provider/dataProvider.dart';

abstract class Authenticator<T extends PDataProvider, USER> {
  final UserState _userState = UserState();
  USER nativeUser;

  PreceptUser get user => preceptUserFromNative(nativeUser);

  USER preceptUserToNative(PreceptUser preceptUser);
  PreceptUser preceptUserFromNative(USER nativeUser);


  Future<bool> registerWithEmail({@required String username, @required String password}) async {
    _userState.status = SignInStatus.Registering;
    final result = await doRegisterWithEmail(username: username, password: password);
    _userState.status =
        (result.success) ? SignInStatus.Registered : SignInStatus.Registration_Failed;
    return result.success;
  }

  Future<AuthenticationResult> doRegisterWithEmail(
      {@required String username, @required String password});

  // TODO: this needs to handle other failures (lost connections etc)
  Future<AuthenticationResult> signInByEmail(
      {@required String username, @required String password}) async {
    _userState.status = SignInStatus.Authenticating;
    final AuthenticationResult result =
        await doSignInByEmail(username: username, password: password);
    if (result.success) {
      _userState.status = SignInStatus.Authenticated;
      return result;
    } else {
      _userState.status = SignInStatus.Authentication_Failed;
      return result;
    }
  }
/// Must set [UserState.sessionToken]
  Future<AuthenticationResult> doSignInByEmail(
      {@required String username, @required String password});

  Future<bool> requestPasswordReset(PreceptUser user) async {
    final result = await doRequestPasswordReset(user);
    if (result) _userState.status = SignInStatus.Reset_Requested;
    return result;
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
    _userState.status = SignInStatus.Removing_Registration;
    final result = await doDeRegister(user);
    _userState.status = (result)
        ? _userState.status = SignInStatus.Registration_Removed
        : SignInStatus.Uninitialized;
    return result;
  }

  Future<bool> doDeRegister(PreceptUser user);

  /// Not sure what this is need for :-)
  registrationAcknowledged() {}

  /// Implementation specific, may not be needed
  init();

  UserState get userState => _userState;
}

enum SignInStatus {
  Uninitialized,
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
  AuthenticationResult({@required this.success, @required this.user, this.errorCode, this.message});
}
