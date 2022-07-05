import 'package:json_annotation/json_annotation.dart';

import '../../data/object/geo.dart';
import '../../script/common.dart';
import 'field.dart';

part 'geo_position.g.dart';

/// see [GeoPosition]
@JsonSerializable(explicitToJson: true)
class FGeoPosition extends Field< GeoPosition> {

  FGeoPosition({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FGeoPosition.fromJson(Map<String, dynamic> json) =>
      _$FGeoPositionFromJson(json);
  @override
  Type get modelType => GeoPoint;

  @override
  Map<String, dynamic> toJson() => _$FGeoPositionToJson(this);
}
