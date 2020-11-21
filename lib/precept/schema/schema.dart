import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/app/data/targetSchema.dart';

/// Contains one or more [SourceSchema] instances, each relating to a specific backend (data source)
class ApplicationSchema {
  final Map<String, SchemaSource> sources;

  const ApplicationSchema({@required this.sources});

  CoreSource get core=> sources["core"] ;
}

abstract class SchemaClass implements SchemaElement {
  final Map<String,SchemaElement> elements;
  final String property;

  const SchemaClass({@required this.elements, this.property});

  /// Returns only the classes from elements
  Map<String,SchemaClass> get classes => throw UnimplementedError();
  Map<String,SchemaField> get fields => throw UnimplementedError();

}


abstract class SchemaSource {
  final Map<String, SchemaClass> classes;

  const SchemaSource({@required this.classes});
}

abstract class SchemaElement {}

/// [T] is the data type to be validated
abstract class SchemaField<T> implements SchemaElement {
  final String property;
  @JsonKey(ignore:true)
  final Validator<T> validator;
  final SchemaPermissions permissions;
  final T defaultValue;

  const SchemaField({@required this.property, this.validator, this.permissions, this.defaultValue});

  bool validate(T value)=> validator.validate(value);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class SchemaString extends SchemaField<String> {
  const SchemaString({@required String property, Validator<String> validator, String defaultValue})
      : super(property: property, validator: validator,defaultValue: defaultValue);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class SchemaBoolean extends SchemaField<bool> {
  const SchemaBoolean({@required String property, Validator<bool> validator, bool defaultValue})
      : super(property: property, validator: validator,defaultValue: defaultValue);
}

abstract class SchemaPermissions {}

/// [T] the data type to be validated
abstract class Validator<T> {
  final bool required;

  const Validator({this.required = false});

  bool validate(T value) {
    if (value == null) {
      return false;
    }
    return doValidate(value);
  }

  bool doValidate(T value);
}
