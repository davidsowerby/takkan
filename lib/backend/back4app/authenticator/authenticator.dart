import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/authenticator.dart';
import 'package:precept_backend/backend/preceptUser.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/schema.dart';

/// This should be instantiated as a Singleton (to keep _parseUser)
/// That is currently done in [PBack4AppDataProvider.register]
class Back4AppAuthenticator implements Authenticator<PBack4AppDataProvider> {
  final Function(SignInStatus) statusCallback;
  ParseUser _parseUser;

  Back4AppAuthenticator({this.statusCallback});

  init() async {}

  /// Username defaults to email address
  Future<bool> signInWithEmail(PreceptUser user, String password) async {
    statusCallback(SignInStatus.Authenticating);
    if (_parseUser == null) {
      _parseUser = ParseUser(user.userName, password, user.email);
      final ParseResponse authResult = await _parseUser.login();
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
    if (_parseUser != null) {
      await _parseUser.logout();

      _parseUser = null;
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
    ParseResponse authResult = await _parseUser.signUp();
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

  @override
  String get configKey => 'back4app';

  @override
  PBack4AppDataProvider dataProvider(
      {@required PSchema schema, @required Map<String, dynamic> jsonConfig}) {
    return PBack4AppDataProvider.fromConfig(schema: schema, jsonConfig: jsonConfig);
  }

}
