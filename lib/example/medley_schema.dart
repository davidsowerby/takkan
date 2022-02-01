import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/version.dart';

final List<PSchema> medleySchema = [medleySchema0];

final PSchema medleySchema0 = PSchema(
  name: 'medley',
  version: PVersion(number: 0),
  documents: {
    'Person': PDocument(fields: {
      'age': PInteger(validations: [
        VInteger.greaterThan(0),
        VInteger.lessThan(128),
      ])
    })
  },
);
