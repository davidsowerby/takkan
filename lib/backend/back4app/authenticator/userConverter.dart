import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';

class Back4AppUserConverter implements PreceptUserConverter<ParseUser> {
  @override
  PreceptUser fromSDK(ParseUser sdkUser) {
    return PreceptUser(
      firstName: sdkUser.authData['firstName'] ?? 'unknown',
      lastName: sdkUser.authData['lastName'] ?? 'unknown',
      knownAs: sdkUser.authData['name'] ?? 'unknown',
      userName: sdkUser.username,
    );
  }

  @override
  ParseUser toSDK(PreceptUser preceptUser) {
    return ParseUser(preceptUser.userName, '?', preceptUser.email);
  }
}
