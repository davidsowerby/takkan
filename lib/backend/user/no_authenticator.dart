import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/provider/data_provider.dart';

class NoAuthenticator
    extends Authenticator<DataProvider, TakkanUser, NoDataProvider> {
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
  init(NoDataProvider parent) {
    logType(this.runtimeType).i("Authenticator not set");
  }

  @override
  TakkanUser takkanUserFromNative(nativeUser) {
    throw UnimplementedError();
  }

  @override
  takkanUserToNative(TakkanUser takkanUser) {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> loadUserRoles() {
    // TODO: implement userRoles
    throw UnimplementedError();
  }

  @override
  doSignOut() {
    // TODO: implement doSignOut
    throw UnimplementedError();
  }
}