import 'package:get_it/get_it.dart';


final GetIt getIt = GetIt.instance;

T inject<T extends Object>() {
  return getIt.get<T>();
}

T injectParam<T extends Object>({param1, param2, String? instanceName}) {
  return getIt.get<T>(instanceName: instanceName, param1: param1, param2: param2);
}


