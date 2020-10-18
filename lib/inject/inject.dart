import 'package:get_it/get_it.dart';
import 'package:precept/inject/modules.dart';

final GetIt getIt = GetIt.instance;

T inject<T>() {
  return getIt.get<T>();
}

void setupInjector(Function() injectorBuilder) {
  injectorBuilder();
}

void preceptInjection() {
  common();
  precept();
}
