import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/object/geo.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'geo_position.g.dart';

/// see [GeoPosition]
@JsonSerializable(explicitToJson: true)
class FGeoPosition extends Field<GeoPositionValidation, GeoPosition> {
  @override
  Type get modelType => GeoPoint;

  FGeoPosition({
    super.defaultValue,
    super.validations = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
  });

  factory FGeoPosition.fromJson(Map<String, dynamic> json) =>
      _$FGeoPositionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FGeoPositionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeoPositionValidation
    implements ModelValidation<ValidateGeoPoint, GeoPoint> {
  @override
  final ValidateGeoPoint method;
  @override
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
