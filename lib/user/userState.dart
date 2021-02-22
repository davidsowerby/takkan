import 'package:precept_backend/backend/authenticator/authenticator.dart';
import 'package:precept_backend/user/preceptUser.dart';

class UserState {
  PreceptUser _user;
  String tenantCode;
  bool newToSystem = true;
  SignInStatus _status;

  SignInStatus get status => _status;
  PreceptUser get user => _user;
}


