import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

T injector<T>() {
  return getIt.get<T>();
}
