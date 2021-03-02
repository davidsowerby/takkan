import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/authenticator/authenticator.dart';
import 'package:precept_backend/backend/authenticator/preceptUser.dart';

class UserState with ChangeNotifier{
  PreceptUser _user;
  String tenantCode;
  bool newToSystem = true;
  SignInStatus _status;

  SignInStatus get status => _status;
  PreceptUser get user => _user;

  bool get isAuthenticated => _status==SignInStatus.Authenticated;
}


