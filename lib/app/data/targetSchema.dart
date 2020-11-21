import 'package:flutter/foundation.dart';
import 'package:precept/precept/schema/schema.dart';

class Sink extends SchemaClass {
  const Sink({@required Map<String, SchemaElement> elements}) : super(elements: elements);

  SchemaString get brand => elements['brand'];
  SchemaString get colour => elements['colour'];
  Location get location => elements['location'];
}

class Location extends SchemaClass {
  const Location({@required Map<String, SchemaElement> elements}) : super(elements: elements);
}

class CoreSource extends SchemaSource {
  const CoreSource({@required Map<String, SchemaClass> classes}) : super(classes: classes);

  Sink get sink => classes["Sink"];
}

final schema = ApplicationSchema(
  sources: {
    "core": CoreSource(
      classes: const {
        "Sink": Sink(
          elements: const {
            "brand": const SchemaString(property: "brand"),
            "colour": const SchemaString(property: "colour"),
            "location": const Location(
              elements: const {
                "upstairs": const SchemaBoolean(property: "upstairs"),
              },
            )
          },
        ),
      },
    ),
  },
);
