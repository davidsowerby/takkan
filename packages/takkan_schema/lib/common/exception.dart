class TakkanException implements Exception {

  const TakkanException(this.msg);
  final String msg;

  String errMsg() => msg;
}

class SchemaException implements Exception {

  const SchemaException(this.msg);
  final String msg;

  String errMsg() => msg;
}
