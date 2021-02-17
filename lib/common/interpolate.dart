String interpolate(String pattern, List<dynamic> params) {
  int count = 0;
  String result = pattern;
  for (var param in params) {
    result = pattern.replaceFirst('{$count}', param.toString());
    count++;
  }
  return result;
}