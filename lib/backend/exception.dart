class APIException implements Exception {
  final String message;
  final int statusCode;

  const APIException({required this.message,required  this.statusCode});

  String errMsg() => message;
}

class APINotSupportedException implements Exception {
  final String message;
  final int statusCode;

  const APINotSupportedException({required this.message,required  this.statusCode});

  String errMsg() => message;
}
