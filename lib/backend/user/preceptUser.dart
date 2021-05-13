import 'package:flutter/foundation.dart';

class PreceptUser {
  final String firstName;
  final String knownAs;
  final String lastName;
  final String email;
  final String userName;
  final bool isUnknown;
  final String objectId;
  final String sessionToken;

  const PreceptUser({
    @required this.firstName,
    this.knownAs,
    @required this.lastName,
    this.email,
    @required this.userName,
    this.objectId,
    this.sessionToken,
  }) : isUnknown = false;

  const PreceptUser.unknownUser()
      : firstName = '',
        knownAs = '',
        lastName = '',
        email = '',
        userName = '',
        objectId = '',
        sessionToken = '',
        isUnknown = true;
}
