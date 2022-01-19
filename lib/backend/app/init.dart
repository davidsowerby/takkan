abstract class AppInitializer {
  Future<InitResult> init(
      {required int step, List<String> argsList = const []});
}

class InitResult {
  final bool ok;
  final Exception? exception;

  const InitResult({required this.ok, this.exception});
}
