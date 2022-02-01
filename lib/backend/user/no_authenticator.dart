import 'package:precept_backend/backend/dataProvider/data_provider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/precept_user.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/data_provider.dart';

class NoAuthenticator extends Authenticator<PDataProvider,PreceptUser,NoDataProvider> {
  final String msg =
      'If authentication is required, an authenticator must be provided by a sub-class of DataProvider';

  @override
  Future<bool> doDeRegister(PreceptUser user) {
    throw UnimplementedError(msg);
  }

  @override
  Future<AuthenticationResult> doRegisterWithEmail(
      {required String username, required String password}) {
    throw UnimplementedError(msg);
  }

  @override
  Future<bool> doRequestPasswordReset(PreceptUser user) {
    throw UnimplementedError(msg);
  }

  @override
  Future<AuthenticationResult> doSignInByEmail(
      {required String username, required String password}) {
    throw UnimplementedError(msg);
  }

  @override
  Future<bool> doUpdateUser(PreceptUser user) {
    throw UnimplementedError(msg);
  }

  @override
  init(NoDataProvider parent) {
    logType(this.runtimeType).i("Authenticator not set");
  }

  @override
  PreceptUser preceptUserFromNative(nativeUser) {
    throw UnimplementedError();
  }

  @override
  preceptUserToNative(PreceptUser preceptUser) {
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