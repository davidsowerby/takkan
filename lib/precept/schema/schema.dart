import 'package:generator/src/annotation/annotation.dart';

part 'schema.g.dart';

/// The root for a backend-agnostic definition of a data structure, including data types, validation
/// and relationships.
///
/// This is just a definition, which is used by Precept, and may or may not be used to create a backend schema.
/// If it is used that way, the interpretation of it is a matter for each [SchemaInterpreter} implementation.
///
///
/// The terminology used reflects the intention to keep this backend-agnostic - there are only 3 classes:
/// - [Schema] the top level, or root of the schema
/// - [SchemaObject], contains [SField] and/or more [SObject]s
/// - [SField], represents a database field
///
/// How these translate to the structure in the backend will depend on the backend itself, and the user's
/// preferences.
///
/// Each level contains [Hints], which can be used to guide a [SchemaInterpreter} implementation.
///
///
///
// @JsonSerializable(nullable: true, explicitToJson: true)
@SchemaGen()
class Schema {
  Map<String, SObject> objects;
}

abstract class SElement {
}

abstract class SObject {
  Map<String, SElement> elements;
}



/// Common interface for a backend-specific interpretation of [Schema]
///
/// An implementation must interpret the Schema in way which acknowledges version changes,
/// and should of course minimise risk of data loss or corruption abstract

class SchemaInterpreter {}

