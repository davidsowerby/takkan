import 'package:flutter/foundation.dart';

Key keys(Key? parentKey, List<String> keys) {
  if (parentKey == null) {
    return Key("${keys.join(':')}");
  }
  final l = parentKey.toString().length;
  final strippedKey = parentKey.toString().substring(3, l - 3);
  return Key("$strippedKey:${keys.join(':')}");
}
