import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/object/geo.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'geo_point.g.dart';

/// see [GeoPoint]
@JsonSerializable(explicitToJson: true)
class FGeoPoint extends Field<GeoPointValidation, GeoPoint> {
  @override
  Type get modelType => GeoPoint;

  FGeoPoint({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  factory FGeoPoint.fromJson(Map<String, dynamic> json) =>
      _$FGeoPointFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FGeoPointToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeoPointValidation
    implements ModelValidation<ValidateGeoPoint, GeoPosition> {
  @override
  final ValidateGeoPoint method;
  @override
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
