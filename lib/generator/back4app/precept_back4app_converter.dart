import 'package:precept_script/schema/schema.dart';

import 'schema_converter.dart';

/// Converts from a Precept [PSchema] to a [Back4AppSchema]
class PreceptBack4AppSchemaConverter {
  Back4AppSchema convert(PSchema pSchema) {
    final Back4AppSchema bSchema =
        Back4AppSchema(results: List.empty(growable: true));
    pSchema.documents.forEach((key, value) {
      bSchema.addClass(ServerSchemaClass.fromPrecept(value));
    });
    return bSchema;
  }
}
