import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/schema/jsonConverter.dart';

part 'schema.g.dart';


/// This is how I would like to create a schema, but it does not play well with the [PreceptModel]
/// There needs to be a code generation step between this and [Schema] but that does not look possible using the standard Dart build_runner.
/// The problem is referencing an instance of this class from within the code generator

/// The root for a backend-agnostic definition of a data structure, including data types, validation
/// and relationships.
///
/// This is just a definition, which is used by Precept, and may or may not be used to create a backend schema.
/// If it is used that way, the interpretation of it is a matter for each [SchemaInterpreter} implementation.
///
///
/// The terminology used reflects the intention to keep this backend-agnostic - see: 
///
/// How these translate to the structure in the backend will depend on the backend itself, and the user's
/// preferences.
///
/// Each level will contain [Hints], which can be used to guide a [SchemaInterpreter} implementation.
///
///
///
@JsonSerializable(nullable: true, explicitToJson: true)
class SModel {
  final Map<String, SComponent> components;

  const SModel({@required this.components});

  factory SModel.fromJson(Map<String, dynamic> json) => _$SModelFromJson(json);

  Map<String, dynamic> toJson() => _$SModelToJson(this);
}

abstract class SElement {
  Map<String, dynamic> toJson();
}

@JsonSerializable(nullable: true, explicitToJson: true)
class SComponent  {
  final Map<String, SDocument> documents;
  const SComponent({@required this.documents}) ;

  factory SComponent.fromJson(Map<String, dynamic> json) =>
      _$SComponentFromJson(json);

  Map<String, dynamic> toJson() => _$SComponentToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class SDocument {
  final Map<String, SSection> sections;

  const SDocument({@required this.sections});

  factory SDocument.fromJson(Map<String, dynamic> json) => _$SDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$SDocumentToJson(this);
}

abstract class SField implements SElement {}

@JsonSerializable(nullable: true, explicitToJson: true)
@SElementMapConverter()
class SSection implements SElement{
  final Map<String, SElement> elements;

  const SSection({@required this.elements});

  factory SSection.fromJson(Map<String, dynamic> json) => _$SSectionFromJson(json);

  Map<String, dynamic> toJson() => _$SSectionToJson(this);

}

@JsonSerializable(nullable: true, explicitToJson: true)
class SBoolean implements SField {
  final bool defaultValue;

  const SBoolean({this.defaultValue});

  factory SBoolean.fromJson(Map<String, dynamic> json) => _$SBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$SBooleanToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class SInteger implements SField {
  final int defaultValue;

  const SInteger({this.defaultValue});

  factory SInteger.fromJson(Map<String, dynamic> json) => _$SIntegerFromJson(json);

  Map<String, dynamic> toJson() => _$SIntegerToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class SString implements SField {
  final String defaultValue;

  const SString({this.defaultValue});

  factory SString.fromJson(Map<String, dynamic> json) => _$SStringFromJson(json);

  Map<String, dynamic> toJson() => _$SStringToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class SDate implements SField{
  final DateTime defaultValue;

  const SDate({this.defaultValue});

  factory SDate.fromJson(Map<String, dynamic> json) => _$SDateFromJson(json);

  Map<String, dynamic> toJson() => _$SDateToJson(this);
}

/// Common interface for a backend-specific interpretation of [SModel]
///
/// An implementation must interpret the Schema in way which acknowledges version changes,
/// and should of course minimise risk of data loss or corruption abstract

class SchemaInterpreter {}
