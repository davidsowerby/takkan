import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:precept_backend/backend/preceptUser.dart';

class Back4AppUserConverter implements PreceptUserConverter<ParseUser> {
  @override
  PreceptUser fromSDK(ParseUser sdkUser) {
    // TODO: implement fromSDK
    throw UnimplementedError();
  }

  @override
  ParseUser toSDK(PreceptUser preceptUser) {
    // TODO: implement toSDK
    throw UnimplementedError();
  }
}
