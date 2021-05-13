import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';

class Back4AppAuthenticator extends Authenticator<PBack4AppDataProvider, ParseUser> {
  Parse parse;
  PBack4AppDataProvider config;

  Back4AppAuthenticator({@required this.config});

  init() async {
    parse = await Parse().initialize(
      config.applicationId,
      config.serverUrl,
      clientKey: config.clientKey,
    );
  }

// TODO: should not allow call if already logged in (_parseUser would be overwritten)
  /// Username defaults to email address
  @protected
  Future<AuthenticationResult> doSignInByEmail(
      {@required String username, @required String password}) async {
    nativeUser = ParseUser(username, password, username);
    nativeUser.password = password;

    final ParseResponse authResult = await nativeUser.login();
    if (authResult.success) {
      final updatedUser = preceptUserFromNative(nativeUser);
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      return AuthenticationResult(
        success: false,
        message: authResult.error.message,
        user: PreceptUser.unknownUser(),
        errorCode: authResult.error.code,
      );
    }
  }

// TODO: should ignore call if already logged out, but log it
  Future<void> signOut() async {
    await nativeUser.logout();
    nativeUser = null;
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
    nativeUser = ParseUser(username, password, username);
    final ParseResponse authResult = await nativeUser.signUp();
    final updatedUser = preceptUserFromNative(nativeUser);
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
    nativeUser = preceptUserToNative(user);
    final result = await nativeUser.requestPasswordReset();
    return result.success;
  }

  @override
  Future<bool> doUpdateUser(PreceptUser user) {
    // TODO: implement doUpdateUser
    throw UnimplementedError();
  }

  @override
  PreceptUser preceptUserFromNative(ParseUser nativeUser) {
    if (nativeUser == null) {
      return PreceptUser.unknownUser();
    }
    final Map<String, dynamic> json = nativeUser.toJson();
    return PreceptUser(
      firstName: json['firstName'] ?? 'unknown',
      lastName: json['lastName'] ?? 'unknown',
      knownAs: json['name'] ?? json['knownAs'] ?? json['firstName'] ?? 'unknown',
      userName: nativeUser.username,
      email: json['email'] ?? 'unknown',
      objectId: json['objectId'],
      sessionToken: json['sessionToken'],
    );
  }

  @override
  ParseUser preceptUserToNative(PreceptUser preceptUser) {
    return ParseUser(preceptUser.userName, '?', preceptUser.email);
  }
}
