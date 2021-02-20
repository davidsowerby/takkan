import 'package:flutter/foundation.dart';

Key keys(Key parentKey, List<String> keys){
  final l=parentKey.toString().length;
  final strippedKey=(parentKey==null) ? '' : parentKey.toString().substring(3,l-3);
  return Key("$strippedKey:${keys.join(':')}");
}

