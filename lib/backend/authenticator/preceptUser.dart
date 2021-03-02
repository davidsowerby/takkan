import 'package:flutter/foundation.dart';

class PreceptUser{
  final String firstName;
  final String knownAs;
  final String lastName;
  final String email;
  final String userName;

  PreceptUser({@required this.firstName, this.knownAs,@required this.lastName, this.email, @required this.userName});
}

/// If an SDK is used to provide a specific backend implementation it will need a way to convert their user
/// class to Precept, and back.
///
/// The implementation of this needs to be added to GetIt in its register method. See :
/// https://www.preceptblog.co.uk/developer-guide/backend-implementation.html#user-converter
abstract class PreceptUserConverter<T>{

  PreceptUser fromSDK(T sdkUser);
  T toSDK (PreceptUser preceptUser);
}