class APIException implements Exception {
  final String message;
  final int statusCode;

  const APIException({this.message, this.statusCode});

  String errMsg() => message;
}

class APINotSupportedException implements Exception {
  final String message;
  final int statusCode;

  const APINotSupportedException({this.message, this.statusCode});

  String errMsg() => message;
}
