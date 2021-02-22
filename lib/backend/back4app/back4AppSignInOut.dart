import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:precept_backend/backend/authenticator/authenticator.dart';
import 'package:precept_backend/backend/authenticator/preceptUser.dart';
import 'package:precept_script/common/log.dart';

class Back4AppSignInOut extends Authenticator {
  final Function(SignInStatus) statusCallback;
  ParseUser _user;

  Back4AppSignInOut({this.statusCallback});

  init() async {}

  /// Username defaults to email address
  Future<bool> signInWithEmail(PreceptUser user, String password) async {
    statusCallback(SignInStatus.Authenticating);
    if (_user == null) {
      _user = ParseUser(user.userName, password, user.email);
      final ParseResponse authResult = await _user.login();
      if (authResult.success) {
        statusCallback(SignInStatus.Authenticated);
        return true;
      } else {
        if (authResult.error.message == "unauthorized") {
          throw UnimplementedError(
              "this could be either a coding error or maybe a lost connection between initial connect and user sign in");
        }
        switch (authResult.error.code) {
          case 101:
            {
              statusCallback(SignInStatus.Authentication_Failed);
              return false;
            }

          /// Invalid username / password
        }
      }
    }

    return false;
  }

  Future<bool> signInWithGoogle() async {
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    statusCallback(SignInStatus.Uninitialized);
    if (_user != null) {
      await _user.logout();

      _user = null;
    }
  }

  Future<void> requestRegistration() async {
    statusCallback(SignInStatus.Registering);
  }

  @override
  Future<bool> deRegister(PreceptUser user) {
    throw UnimplementedError();
  }

  @override
  Future<bool> registerWithEmail(PreceptUser user) async {
    statusCallback(SignInStatus.Registering);
    ParseResponse authResult = await _user.signUp();
    if (authResult.success) {
      statusCallback(SignInStatus.Registered);
      return true;
    }
    logType(this.runtimeType).e(authResult.error.message);
    statusCallback(SignInStatus.RegistrationFailed);
    return false;
  }

  @override
  Future<bool> requestPasswordReset(PreceptUser user) {
    // TODO: implement requestPasswordReset
    throw UnimplementedError();
  }

  @override
  Future<bool> signInByEmail(PreceptUser user) {
    // TODO: implement signInByEmail
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUser(PreceptUser user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
