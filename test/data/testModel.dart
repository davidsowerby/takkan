import 'package:precept/precept/model/precept-signin.dart';
import 'package:precept/precept/model/precept.dart';

final testModel = Precept((b) => b
  ..signIn.backend = Backend.back4app
  ..signIn.brand = "wiggly"
  ..components.addAll([
    PreceptComponent(
      (b) => b
        ..name = "core"
        ..sections.addAll([])
        ..routes.addAll([
          PreceptRoute((b) => b
            ..path = "/home"
            ..page.title = "Home"
            ..page.sections.addAll([]))
        ]),
    )
  ]));

page() {
  return PreceptPage((b) => b.title = "Home");
}
