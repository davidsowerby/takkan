import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';

class UserState {
  PreceptUser _user = PreceptUser.unknownUser();
  String tenantCode = '';
  bool newToSystem = true;
  SignInStatus _status = SignInStatus.Uninitialized;

  SignInStatus get status => _status;

  PreceptUser get user => _user;

  bool get isAuthenticated => _status == SignInStatus.Authenticated;

  set status(SignInStatus value) {
    _status = value;
    notifyListeners();
  }

  void notifyListeners() {}
}
