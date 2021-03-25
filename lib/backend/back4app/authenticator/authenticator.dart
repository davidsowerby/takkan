import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/authenticator/userConverter.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';

class Back4AppAuthenticator extends Authenticator<PBack4AppDataProvider> {
  ParseUser _parseUser;
  Parse parse;
  PBack4AppDataProvider config;

  Back4AppAuthenticator({@required this.config});

  init() async {
    // parse = await Parse().initialize(config.applicationId, config.serverUrl);
    throw UnimplementedError();
  }

// TODO: should not allow call if already logged in (_parseUser would be overwritten)
  /// Username defaults to email address
  @protected
  Future<AuthenticationResult> doSignInByEmail(
      {@required String username, @required String password}) async {
    final userConverter = Back4AppUserConverter();
    _parseUser = ParseUser(username, password, username);
    _parseUser.password = password;
    final ParseResponse authResult = await _parseUser.login();
    if (authResult.success) {
      final updatedUser = userConverter.fromSDK(_parseUser);
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      if (authResult.error.code == 101) {
        return AuthenticationResult(success: false, errorCode: -1, user: PreceptUser.unknownUser());
      }
      return AuthenticationResult(
          success: false, message: authResult.error.message, user: PreceptUser.unknownUser());
    }
  }

// TODO: should ignore call if already logged out, but log it
  Future<void> signOut() async {
    await _parseUser.logout();
    _parseUser = null;
  }

  @override
  Future<bool> doDeRegister(PreceptUser user) {
    // TODO: implement doDeRegister
    throw UnimplementedError();
  }

  // TODO: should not allow call if already logged in (_parseUser would be overwritten)
  @override
  Future<AuthenticationResult> doRegisterWithEmail(
      {@required String username, @required String password}) async {
    final userConverter = Back4AppUserConverter();
    _parseUser = ParseUser(username, password, username);
    final ParseResponse authResult = await _parseUser.signUp();
    final updatedUser = userConverter.fromSDK(_parseUser);
    if (authResult.success) {
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      if (authResult.error.code == 101) {
        return AuthenticationResult(success: false, errorCode: -1, user: PreceptUser.unknownUser());
      }
      return AuthenticationResult(
          success: false, message: authResult.error.message, user: PreceptUser.unknownUser());
    }
  }

  @override
  Future<bool> doRequestPasswordReset(PreceptUser user) async {
    final userConverter = Back4AppUserConverter();
    _parseUser = userConverter.toSDK(user);
    final result = await _parseUser.requestPasswordReset();
    return result.success;
  }

  @override
  Future<bool> doUpdateUser(PreceptUser user) {
    // TODO: implement doUpdateUser
    throw UnimplementedError();
  }
}
