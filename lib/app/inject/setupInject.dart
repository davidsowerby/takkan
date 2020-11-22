import 'package:precept_client/app/data/kitchenSink.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/loader.dart';
import 'package:precept_client/precept/precept.dart';

injectorBindings() {
  preceptInjection();
  getIt.registerSingleton<Precept>(
      Precept(loaders: [DirectPreceptLoader(model: kitchenSinkModel)]));
}
