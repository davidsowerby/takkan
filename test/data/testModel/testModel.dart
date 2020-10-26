import 'package:precept/precept/model/precept-signin.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:precept/precept/part/library/partLibrary.dart';

final testModel = Precept((b) => b
  ..signIn.backend = Backend.back4app
  ..signIn.brand = "wiggly"
  ..components.addAll([
    PreceptComponent(
      (b) => b
        ..name = "core"
        ..parts.addAll({
          CorePart.address: PreceptPart((b) => b
            ..caption = "Address"
            ..fields.addAll([]))
        })
        ..routes.addAll([
          PreceptRoute((b) => b
            ..path = "/home"
            ..page.title = "Home"
            ..page.sections.addAll(
                [PreceptSection((b) => b..sectionKey = CorePart.address)]))
        ]),
    )
  ]));

page() {
  return PreceptPage((b) => b.title = "Home");
}


