import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/object/geo.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'geoPosition.g.dart';

/// see [GeoPosition]
@JsonSerializable(explicitToJson: true)
class PGeoPosition extends PField<GeoPositionValidation, GeoPosition> {
  Type get modelType => GeoPoint;

  PGeoPosition({
    GeoPosition? defaultValue,
    List<GeoPositionValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
    readOnly: readOnly,
          defaultValue: defaultValue,
          required: required,
          validations: validations,
        );

  factory PGeoPosition.fromJson(Map<String, dynamic> json) =>
      _$PGeoPositionFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPositionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeoPositionValidation
    implements ModelValidation<ValidateGeoPoint, GeoPoint> {
  final ValidateGeoPoint method;
  final GeoPoint? param;

  const GeoPositionValidation({required this.method, this.param});

  factory GeoPositionValidation.fromJson(Map<String, dynamic> json) =>
      _$GeoPositionValidationFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPositionValidationToJson(this);
}

// TODO: needs things like 'isLessThan X distanceUnits from Y', or isInLocale??
enum ValidateGeoPoint { isValid }

validateGeoPosition(GeoPositionValidation validation, GeoPosition value) {
  switch (validation.method) {
    case ValidateGeoPoint.isValid:
      return true;
  }
}
