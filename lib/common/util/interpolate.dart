
/// replace with [interpolate], but that also means moving to client package
@deprecated
String expandErrorMessage(String pattern, List<dynamic> params) {
  int count = 0;
  String result = pattern;
  for (var param in params) {
    result = pattern.replaceFirst('{$count}', param.toString());
    count++;
  }
  return result;
}
