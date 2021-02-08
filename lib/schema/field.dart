import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/geoPosition.dart';
import 'package:precept_script/data/pointer.dart';
import 'package:precept_script/data/postCode.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'field.g.dart';

abstract class PField<MODEL> extends PSchemaElement {
  final List<Validation> validations;

  Type get modelType;

  PField({this.validations});

  validate(MODEL value) {
    if (validations == null || validations.isEmpty) {
      return null;
    }
    return FieldValidator<MODEL>(field: this).validate(value);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PBoolean extends PField<bool> {
  final bool defaultValue;

  PBoolean({this.defaultValue, List<Validation> validations}) : super(validations: validations);

  Type get modelType => bool;

  factory PBoolean.fromJson(Map<String, dynamic> json) => _$PBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$PBooleanToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PInteger extends PField<int> {
  final int defaultValue;

  Type get modelType => int;

  PInteger({this.defaultValue, List<Validation> validations}) : super(validations: validations);

  factory PInteger.fromJson(Map<String, dynamic> json) => _$PIntegerFromJson(json);

  Map<String, dynamic> toJson() => _$PIntegerToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PField<String> {
  final String defaultValue;

  PString({this.defaultValue, List<Validation> validations}) : super(validations: validations);

  Type get modelType => String;

  factory PString.fromJson(Map<String, dynamic> json) => _$PStringFromJson(json);

  Map<String, dynamic> toJson() => _$PStringToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PDate extends PField<DateTime> {
  final DateTime defaultValue;

  Type get modelType => DateTime;

  PDate({this.defaultValue, List<Validation> validations}) : super(validations: validations);

  factory PDate.fromJson(Map<String, dynamic> json) => _$PDateFromJson(json);

  Map<String, dynamic> toJson() => _$PDateToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPointer extends PField<Pointer> {
  PPointer({List<Validation> validations}) : super(validations: validations);

  Type get modelType => Pointer;

  factory PPointer.fromJson(Map<String, dynamic> json) => _$PPointerFromJson(json);

  Map<String, dynamic> toJson() => _$PPointerToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PDouble extends PField<double> {
  final double defaultValue;

  PDouble({this.defaultValue = 0.0, List<Validation> validations})
      : super(validations: validations);

  Type get modelType => double;

  factory PDouble.fromJson(Map<String, dynamic> json) => _$PDoubleFromJson(json);

  Map<String, dynamic> toJson() => _$PDoubleToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoPosition extends PField<GeoPosition> {
  final GeoPosition defaultValue;

  PGeoPosition({this.defaultValue, List<Validation> validations}) : super(validations: validations);

  Type get modelType => GeoPosition;

  factory PGeoPosition.fromJson(Map<String, dynamic> json) => _$PGeoPositionFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPositionToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPostCode extends PField<PostCode> {
  final PostCode defaultValue;

  PPostCode({this.defaultValue, List<Validation> validations}) : super(validations: validations);

  Type get modelType => PostCode;

  factory PPostCode.fromJson(Map<String, dynamic> json) => _$PPostCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PPostCodeToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoLocation extends PField<GeoLocation> {
  final GeoLocation defaultValue;

  PGeoLocation({this.defaultValue, List<Validation> validations}) : super(validations: validations);

  Type get modelType => GeoLocation;

  factory PGeoLocation.fromJson(Map<String, dynamic> json) => _$PGeoLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoLocationToJson(this);
}
