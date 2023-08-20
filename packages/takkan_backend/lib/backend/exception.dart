class APIException implements Exception {
  const APIException({required this.message, required this.statusCode});
  final String message;
  final int statusCode;

  String errMsg() => message;
}

class APINotSupportedException implements Exception {
  const APINotSupportedException(
      {required this.message, required this.statusCode});
  final String message;
  final int statusCode;

  String errMsg() => message;
}
