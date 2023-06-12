import 'package:meta/meta.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:takkan_back4app_client/backend/back4app/provider/data_provider.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/data/provider/data_provider.dart';

class Back4AppAuthenticator extends Authenticator<DataProvider, ParseUser> {
  late Parse parse;

  Back4AppAuthenticator(super.parent);

  @override
  Future<SignInStatus> init() async {
    super.init();
    // TODO: using 'p' is a horrible hack should be able to type correctly though construction
    final p=parent as Back4AppDataProvider;
    parse = await Parse().initialize(
      p.instanceConfig.appId,
      p.instanceConfig.serverUrl,
      clientKey: p.instanceConfig.clientKey,
    );
    status = SignInStatus.Initialised;
    return status;
  }

// TODO: should not allow call if already logged in (_parseUser would be overwritten)
  /// Username defaults to email address
  @protected
  Future<AuthenticationResult> doSignInByEmail(
      {required String username, required String password}) async {
    final nativeUser = ParseUser(username, password, username);
    nativeUser.password = password;
    this.nativeUser = nativeUser;
    final ParseResponse authResult = await nativeUser.login();
    if (authResult.success) {
      final updatedUser = takkanUserFromNative(nativeUser);
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      return AuthenticationResult(
        success: false,
        message: authResult.error?.message ?? 'Unknown',
        user: TakkanUser.unknownUser(),
        errorCode: authResult.error?.code ?? -999,
      );
    }
  }

  Future<void> doSignOut() async {
    await nativeUser?.logout();
  }

  @override
  Future<bool> doDeRegister(TakkanUser user) {
    // TODO: implement doDeRegister
    throw UnimplementedError();
  }

  // TODO: should not allow call if already logged in (_parseUser would be overwritten)
  @override
  Future<AuthenticationResult> doRegisterWithEmail(
      {required String username, required String password}) async {
    final nativeUser = ParseUser(username, password, username);
    final ParseResponse authResult = await nativeUser.signUp();
    final updatedUser = takkanUserFromNative(nativeUser);
    this.nativeUser = nativeUser;
    if (authResult.success) {
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      final errorCode = authResult.error?.code ?? -999;
      if (errorCode == 101) {
        return AuthenticationResult(
            success: false, errorCode: -1, user: TakkanUser.unknownUser());
      }
      return AuthenticationResult(
          success: false,
          message: authResult.error?.message ?? 'Unknown',
          user: TakkanUser.unknownUser());
    }
  }

  @override
  Future<bool> doRequestPasswordReset(TakkanUser user) async {
    final nativeUser = takkanUserToNative(user);
    final result = await nativeUser.requestPasswordReset();
    this.nativeUser = nativeUser;
    return result.success;
  }

  @override
  Future<bool> doUpdateUser(TakkanUser user) {
    // TODO: implement doUpdateUser
    throw UnimplementedError();
  }

  @override
  TakkanUser takkanUserFromNative(ParseUser? nativeUser) {
    if (nativeUser == null) {
      return TakkanUser.unknownUser();
    }
    // ignore: invalid_use_of_protected_member
    final Map<String, dynamic> json = nativeUser.toJson();
    return TakkanUser.fromJson(json);
  }

  @override
  ParseUser takkanUserToNative(TakkanUser takkanUser) {
    return ParseUser(takkanUser.userName, '?', takkanUser.email);
  }

  @override
  Future<List<String>> loadUserRoles() async {
//TODO: get user roles from cloud function
    throw UnimplementedError();
  }
}
