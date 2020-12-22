import 'package:precept_schema/schema/schema.dart';

final schema = const SSchema(components: {
  "core": SComponent(documents: {
    "sink": SDocument(
      models: {
        "": SModel(
          elements: {
            "firstName": SString(),
            "age": SInteger(defaultValue: 0),
          },
        ),
      },
    )
  }),
});
