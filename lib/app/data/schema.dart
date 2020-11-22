import 'package:precept/precept/schema/schema.dart';

final schema = const SModel(components: {
  "core": SComponent(documents: {
    "sink": SDocument(
      sections: {
        "": SSection(
          elements: {
            "firstName": SString(),
            "age": SInteger(defaultValue: 0),
          },
        ),
      },
    )
  }),
});
