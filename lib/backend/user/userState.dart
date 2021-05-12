import 'package:precept_backend/backend/user/authenticator.dart';

class UserState {

  String tenantCode = '';
  bool newToSystem = true;
  SignInStatus _status = SignInStatus.Uninitialized;

  SignInStatus get status => _status;



  bool get isAuthenticated => _status == SignInStatus.Authenticated;

  set status(SignInStatus value) {
    _status = value;
    notifyListeners();
  }

  void notifyListeners() {}
}
