/// replace with [interpolate], but that also means moving to client package
@Deprecated('replace with interpolate')
String expandErrorMessage(String pattern, Map<String, dynamic> params,
    {bool operandIsString = false}) {
  String result = pattern;
  for (final entry in params.entries) {
    result = operandIsString
        ? result.replaceAll('{${entry.key}}', "'${entry.value}'")
        : result.replaceAll('{${entry.key}}', entry.value.toString());
  }
  return result;
}
