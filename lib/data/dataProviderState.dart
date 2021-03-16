import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/userState.dart';

class DataProviderState with ChangeNotifier{
  final DataProvider dataProvider;

  DataProviderState(this.dataProvider);

  bool get isAuthenticated => dataProvider.userState.isAuthenticated;

  Authenticator get authenticator => dataProvider.authenticator;

  UserState get userState => dataProvider.userState;
}