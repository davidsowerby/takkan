import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/geoPosition.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'geoPosition.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoPosition extends PField<GeoPositionValidation,GeoPosition> {
  final GeoPosition defaultValue;

  Type get modelType => GeoPosition;

  PGeoPosition({this.defaultValue, List<GeoPositionValidation> validations}) : super(validations: validations);

  factory PGeoPosition.fromJson(Map<String, dynamic> json) => _$PGeoPositionFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPositionToJson(this);

  @override
  bool doValidation(GeoPositionValidation validation, GeoPosition value) {
    return validateGeoPosition(validation, value);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class GeoPositionValidation implements ModelValidation<ValidateGeoPosition, GeoPosition> {
  final ValidateGeoPosition method;
  final GeoPosition param;

  const GeoPositionValidation({@required this.method, this.param});

  factory GeoPositionValidation.fromJson(Map<String, dynamic> json) =>
      _$GeoPositionValidationFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPositionValidationToJson(this);
}

// TODO: needs things like 'isLessThan X distanceUnits from Y', or isInLocale??
enum ValidateGeoPosition { isValid }

validateGeoPosition(GeoPositionValidation validation, GeoPosition value) {
  switch (validation.method) {
    case ValidateGeoPosition.isValid:
      return true;
  }
}

