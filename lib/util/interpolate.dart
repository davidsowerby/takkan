
/// replace with [interpolate], but that also means moving to client package
@Deprecated('replace with interpolate')
String expandErrorMessage(String pattern, Map<String, dynamic> params) {
  String result = pattern;
  for (final entry in params.entries) {
    result = result.replaceAll('{${entry.key}}', entry.value.toString());
  }
  return result;
}
