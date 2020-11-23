import 'package:precept_client/inject/inject.dart';

class PreceptInit {
  static injection({List<Function()> injections = const [], bool includePreceptDefaults=true}) async {
    if (includePreceptDefaults || injections == null || injections.isEmpty) {
      preceptDefaultInjectionBindings();
    }
  }
}
