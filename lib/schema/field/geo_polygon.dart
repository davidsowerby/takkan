import 'package:json_annotation/json_annotation.dart';

import '../../data/object/geo.dart';
import '../../data/select/condition/condition.dart';
import '../../script/common.dart';
import 'field.dart';

part 'geo_polygon.g.dart';

/// see [GeoPolygon]
@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FGeoPolygon extends Field< GeoPolygon> {

  FGeoPolygon({
    super.defaultValue,
    super. constraints = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
    super.validation,
  }) ;

  factory FGeoPolygon.fromJson(Map<String, dynamic> json) =>
      _$FGeoPolygonFromJson(json);
  @override
  Type get modelType => GeoPolygon;

  @override
  Map<String, dynamic> toJson() => _$FGeoPolygonToJson(this);
}
