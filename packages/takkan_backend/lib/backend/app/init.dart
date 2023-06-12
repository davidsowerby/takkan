abstract class AppInitializer {
  Future<InitResult> init(
      {required int step, List<String> argsList = const []});
}

class InitResult {

  const InitResult({required this.ok, this.exception});
  final bool ok;
  final Exception? exception;
}
