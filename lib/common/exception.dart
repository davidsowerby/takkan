class TakkanException implements Exception {
  final String msg;

  const TakkanException(this.msg);

  String errMsg() => msg;
}

class SchemaException implements Exception {
  final String msg;

  const SchemaException(this.msg);

  String errMsg() => msg;
}
