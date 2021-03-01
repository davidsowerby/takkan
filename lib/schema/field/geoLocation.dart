import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/geoPosition.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'geoLocation.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoLocation extends PField<GeoLocationValidation, GeoLocation> {
  final GeoLocation defaultValue;

  Type get modelType => GeoLocation;

  PGeoLocation({
    this.defaultValue,
    List<GeoLocationValidation> validations,
    Permissions permissions,
  }) : super(
          validations: validations,
          permissions: permissions,
        );

  factory PGeoLocation.fromJson(Map<String, dynamic> json) => _$PGeoLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoLocationToJson(this);

  @override
  bool doValidation(GeoLocationValidation validation, GeoLocation value) {
    return validateGeoLocation(validation, value);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class GeoLocationValidation implements ModelValidation<ValidateGeoLocation, GeoLocation> {
  final ValidateGeoLocation method;
  final GeoLocation param;

  const GeoLocationValidation({@required this.method, this.param});

  factory GeoLocationValidation.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationValidationFromJson(json);

  Map<String, dynamic> toJson() => _$GeoLocationValidationToJson(this);
}

// TODO: needs things like 'isLessThan X distanceUnits from Y', or isInLocale??
enum ValidateGeoLocation { isValid }

validateGeoLocation(GeoLocationValidation validation, GeoLocation value) {
  switch (validation.method) {
    case ValidateGeoLocation.isValid:
      return true;
  }
}
