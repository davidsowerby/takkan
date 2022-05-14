import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/object/geo.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'geo_polygon.g.dart';

/// see [GeoPolygon]
@JsonSerializable(explicitToJson: true)
class FGeoPolygon extends Field<GeoPolygonValidation, GeoPolygon> {
  Type get modelType => GeoPolygon;

  FGeoPolygon({
    GeoPolygon? defaultValue,
    List<GeoPolygonValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
          readOnly: readOnly,
          defaultValue: defaultValue,
          required: required,
          validations: validations,
        );

  factory FGeoPolygon.fromJson(Map<String, dynamic> json) =>
      _$FGeoPolygonFromJson(json);

  Map<String, dynamic> toJson() => _$FGeoPolygonToJson(this);
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
