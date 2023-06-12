class TestException implements Exception {
  final String msg;

  const TestException(this.msg);

  String errMsg() => msg;
}
