import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/object/geo.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'geoPolygon.g.dart';

/// see [GeoPolygon]
@JsonSerializable(explicitToJson: true)
class PGeoPolygon extends PField<GeoPolygonValidation, GeoPolygon> {
  Type get modelType => GeoPolygon;

  PGeoPolygon({
    GeoPolygon? defaultValue,
    List<GeoPolygonValidation> validations = const [],
    PPermissions? permissions,
    bool required = false,
  }) : super(
          defaultValue: defaultValue,
          required: required,
          validations: validations,
          permissions: permissions,
        );

  factory PGeoPolygon.fromJson(Map<String, dynamic> json) =>
      _$PGeoPolygonFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPolygonToJson(this);

  @override
  bool doValidation(GeoPolygonValidation validation, GeoPolygon value) {
    return validateGeoPolygon(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class GeoPolygonValidation
    implements ModelValidation<ValidateGeoPoint, GeoPoint> {
  final ValidateGeoPoint method;
  final GeoPoint? param;

  const GeoPolygonValidation({required this.method, this.param});

  factory GeoPolygonValidation.fromJson(Map<String, dynamic> json) =>
      _$GeoPolygonValidationFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPolygonValidationToJson(this);
}

// TODO: needs things like 'isLessThan X distanceUnits from Y', or isInLocale??
enum ValidateGeoPoint { isValid }

validateGeoPolygon(GeoPolygonValidation validation, GeoPolygon value) {
  switch (validation.method) {
    case ValidateGeoPoint.isValid:
      return true;
  }
}
