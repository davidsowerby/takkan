class ConfigurationException implements Exception {
  final String msg;

  const ConfigurationException(this.msg);

  String errMsg() => msg;
}


class NYIException implements Exception {
  String errMsg() => 'not yet implemented';
}
