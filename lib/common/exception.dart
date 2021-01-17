class PreceptException implements Exception {
  final String msg;

  const PreceptException(this.msg);

  String errMsg() => msg;
}

class SchemaException implements Exception {
  final String msg;

  const SchemaException(this.msg);

  String errMsg() => msg;
}
