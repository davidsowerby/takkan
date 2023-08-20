import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/data/provider/data_provider.dart';

import 'authenticator.dart';
import 'takkan_user.dart';

class NoAuthenticator extends Authenticator<DataProvider, TakkanUser> {
  NoAuthenticator(super.parent);
  final String msg =
      'If authentication is required, an authenticator must be provided by a sub-class of DataProvider';

  @override
  Future<bool> doDeRegister(TakkanUser user) {
    throw UnimplementedError(msg);
  }

  @override
  Future<AuthenticationResult> doRegisterWithEmail(
      {required String username, required String password}) {
    throw UnimplementedError(msg);
  }

  @override
  Future<bool> doRequestPasswordReset(TakkanUser user) {
    throw UnimplementedError(msg);
  }

  @override
  Future<AuthenticationResult> doSignInByEmail(
      {required String username, required String password}) {
    throw UnimplementedError(msg);
  }

  @override
  Future<bool> doUpdateUser(TakkanUser user) {
    throw UnimplementedError(msg);
  }

  @override
  Future<SignInStatus> init() async {
    super.init();
    logType(runtimeType)
        .i("Using a 'NoAuthenticator' so real authentication not possible");
    return status;
  }

  @override
  TakkanUser takkanUserFromNative(nativeUser) {
    throw UnimplementedError();
  }

  @override
  TakkanUser takkanUserToNative(TakkanUser takkanUser) {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> loadUserRoles() {
    throw UnimplementedError();
  }

  @override
  Future<void> doSignOut() {
    throw UnimplementedError();
  }
}
