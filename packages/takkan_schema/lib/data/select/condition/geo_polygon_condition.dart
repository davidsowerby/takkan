import 'package:json_annotation/json_annotation.dart';

import '../../object/geo.dart';
import 'condition.dart';

part 'geo_polygon_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [Q] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class GeoPolygonConditionBuilder {
  GeoPolygonConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  GeoPolygonCondition equalTo(GeoPolygon operand) {
    return GeoPolygonCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  GeoPolygonCondition notEqualTo(GeoPolygon operand) {
    return GeoPolygonCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GeoPolygonCondition extends Condition<GeoPolygon> {
  const GeoPolygonCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory GeoPolygonCondition.fromJson(Map<String, dynamic> json) =>
      _$GeoPolygonConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(GeoPolygon value) {
    switch (operator) {
      case Operator.equalTo:
        return value == operand;
      case Operator.notEqualTo:
        return value != operand;
      default:
        return throwOperatorInvalid();
    }
  }

  @override
  List<Operator> get notValidForType => [...lengthOperations];

  @override
  Map<String, dynamic> toJson() => _$GeoPolygonConditionToJson(this);

  @override
  GeoPolygonCondition withField(String field) {
    return GeoPolygonCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
