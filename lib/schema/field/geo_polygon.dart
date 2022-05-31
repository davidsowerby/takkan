import 'package:json_annotation/json_annotation.dart';

import '../../data/object/geo.dart';
import '../../script/common.dart';
import '../validation/validator.dart';
import 'field.dart';

part 'geo_polygon.g.dart';

/// see [GeoPolygon]
@JsonSerializable(explicitToJson: true)
class FGeoPolygon extends Field<GeoPolygonValidation, GeoPolygon> {
  @override
  Type get modelType => GeoPolygon;

  FGeoPolygon({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  factory FGeoPolygon.fromJson(Map<String, dynamic> json) =>
      _$FGeoPolygonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FGeoPolygonToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeoPolygonValidation
    implements ModelValidation<ValidateGeoPoint, GeoPoint> {
  @override
  final ValidateGeoPoint method;
  @override
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
