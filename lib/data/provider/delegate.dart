/// Common base class for delegates to PDataProvider
abstract class PDataProviderDelegate {
  final String sessionTokenKey;
  final bool checkHealthOnConnect;
  final List<String> headerKeys;

  const PDataProviderDelegate(
      {required this.sessionTokenKey,
      this.checkHealthOnConnect = false,
      this.headerKeys = const []});
}
