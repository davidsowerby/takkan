import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/object/geo.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'geo_point.g.dart';

/// see [GeoPoint]
@JsonSerializable(explicitToJson: true)
class PGeoPoint extends PField<GeoPointValidation, GeoPoint> {
  Type get modelType => GeoPoint;

  PGeoPoint({
    GeoPoint? defaultValue,
    List<GeoPointValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
    defaultValue: defaultValue,
          validations: validations,
          required: required,
          readOnly: readOnly,
        );

  factory PGeoPoint.fromJson(Map<String, dynamic> json) =>
      _$PGeoPointFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPointToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeoPointValidation
    implements ModelValidation<ValidateGeoPoint, GeoPosition> {
  final ValidateGeoPoint method;
  final GeoPoint? param;

  const GeoPointValidation({required this.method, this.param});

  factory GeoPointValidation.fromJson(Map<String, dynamic> json) =>
      _$GeoPointValidationFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPointValidationToJson(this);
}

// TODO: needs things like 'isLessThan X distanceUnits from Y', or isInLocale??
enum ValidateGeoPoint { isValid }

validateGeoPoint(GeoPointValidation validation, GeoPoint value) {
  switch (validation.method) {
    case ValidateGeoPoint.isValid:
      return true;
  }
}
