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
        ..widgets.addAll({
          CoreSection.address: PreceptWidget((b) => b
            ..caption = "Address"
            ..fields.addAll([]))
        })
        ..routes.addAll([
          PreceptRoute((b) => b
            ..path = "/home"
            ..page.title = "Home"
            ..page.sections.addAll(
                [PreceptSection((b) => b..sectionKey = CoreSection.address)]))
        ]),
    )
  ]));

page() {
  return PreceptPage((b) => b.title = "Home");
}

class CoreSection extends EnumClass {
  static const CoreSection address = _$address;
  static const CoreSection contact = _$contact;

  const CoreSection._(String name) : super(name);

  static BuiltSet<CoreSection> get values => _$values;

  static CoreSection valueOf(String name) => _$valueOf(name);

  static Serializer<CoreSection> get serializer => _$coreSectionSerializer;
}
