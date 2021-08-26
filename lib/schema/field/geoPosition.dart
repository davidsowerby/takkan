import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/object/geoPosition.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'geoPosition.g.dart';

@JsonSerializable(explicitToJson: true)
class PGeoPosition extends PField<GeoPositionValidation, GeoPosition> {
  Type get modelType => GeoPosition;

  PGeoPosition({
    GeoPosition? defaultValue,
    List<GeoPositionValidation> validations = const [],
    PPermissions? permissions,
    bool required = false,
  }) : super(
          defaultValue: defaultValue,
          required: required,
          validations: validations,
          permissions: permissions,
        );

  factory PGeoPosition.fromJson(Map<String, dynamic> json) =>
      _$PGeoPositionFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPositionToJson(this);

  @override
  bool doValidation(GeoPositionValidation validation, GeoPosition value) {
    return validateGeoPosition(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class GeoPositionValidation
    implements ModelValidation<ValidateGeoPosition, GeoPosition> {
  final ValidateGeoPosition method;
  final GeoPosition? param;

  const GeoPositionValidation({required this.method, this.param});

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
