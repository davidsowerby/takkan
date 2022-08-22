// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/common/constants.dart';

import '../../data/object/geo.dart';
import '../../data/select/condition/condition.dart';
import 'field.dart';

part 'geo_point.g.dart';

/// see [GeoPoint]
@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FGeoPoint extends Field<GeoPoint> {
  FGeoPoint({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FGeoPoint.fromJson(Map<String, dynamic> json) =>
      _$FGeoPointFromJson(json);

  @override
  Type get modelType => GeoPoint;

  @override
  Map<String, dynamic> toJson() => _$FGeoPointToJson(this);
}
