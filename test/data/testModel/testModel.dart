import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:precept/precept/model/precept-signin.dart';
import 'package:precept/precept/model/precept.dart';

part 'testModel.g.dart';

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

class CorePart extends EnumClass {
  static const CorePart address = _$address;
  static const CorePart contact = _$contact;

  const CorePart._(String name) : super(name);

  static BuiltSet<CorePart> get values => _$values;

  static CorePart valueOf(String name) => _$valueOf(name);

  static Serializer<CorePart> get serializer => _$corePartSerializer;
}
