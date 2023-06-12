import 'package:flutter/widgets.dart';

/// Replaces placeholders in a pattern with values.  For example:
///
/// A pattern of:
///
/// - 'Hello {name}'
///
/// Becomes:
///
/// - 'Hello David'
///
/// Assuming that [getValue] returns a value of 'David for a key of 'name'
///
/// It is not currently possible to escape a '{', see https://gitlab.com/takkan/takkan_client/-/issues/121
mixin Interpolator {
  String doInterpolate(String pattern, dynamic Function(String) getValue) {
    final outBuf = StringBuffer();
    Characters source = Characters(pattern);
    bool done=false;
    while (source.isNotEmpty && !done) {
      final range = source.findFirst('{'.characters);
      if (range != null && range.moveUntil('}'.characters)) {
        outBuf.write(range.charactersBefore.skipLast(1));
        final String key = range.currentCharacters.string;
        outBuf.write(getValue(key) ?? '?');
        source = range.charactersAfter.skip(1);
      }
      if (range == null) {
        outBuf.write(source.string);
        done=true;
      }
    }
    return outBuf.toString();
  }
}