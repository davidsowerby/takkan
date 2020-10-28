import 'package:precept/app/data/kitchenSink.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/loader.dart';
import 'package:precept/precept/precept.dart';

injectorBindings() {
  preceptInjection();
  getIt.registerSingleton<Precept>(
      Precept(loaders: [DirectPreceptLoader(model: kitchenSinkModel)]));
}
