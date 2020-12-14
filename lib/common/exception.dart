class PreceptException implements Exception {
  final String msg;

  const PreceptException(this.msg);

  String errMsg() => msg;
}
