import 'package:get_it/get_it.dart';
import 'package:precept_client/inject/modules.dart';

final GetIt getIt = GetIt.instance;

T inject<T>() {
  return getIt.get<T>();
}

T injectParam<T>({param1, param2, String instanceName}) {
  return getIt.get<T>(instanceName: instanceName, param1: param1, param2: param2);
}

void preceptDefaultInjectionBindings() {
  commonInjectionBindings();
  libraryInjectionBindings();
  documentInjectionBindings();
  routerInjectionBindings();
  themeInjectionBindings();
}
