import 'package:flutter/foundation.dart';

class PreceptUser{
  final String firstName;
  final String knownAs;
  final String lastName;
  final String email;
  final String userName;

  PreceptUser({@required this.firstName, this.knownAs,@required this.lastName, this.email, @required this.userName});
}