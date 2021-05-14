import 'package:flutter/cupertino.dart';
import 'package:precept_backend/backend/user/authenticator.dart';

class UserState with ChangeNotifier {
  final Authenticator authenticator;

  String tenantCode = '';
  bool newToSystem = true;

  UserState(this.authenticator) {
    authenticator.addSignInStatusListener(statusChange);
  }

  SignInStatus get status => authenticator.status;

  statusChange(SignInStatus newStatus) {
    notifyListeners();
  }
}
