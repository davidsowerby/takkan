
/// replace with [interpolate], but that also means moving to client package
@deprecated
String expandErrorMessage(String pattern, Map<String, dynamic> params) {
  String result = pattern;
  for (var entry in params.entries) {
    result = result.replaceAll('{${entry.key}}', entry.value.toString());
  }
  return result;
}
