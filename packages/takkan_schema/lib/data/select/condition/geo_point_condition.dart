import 'package:json_annotation/json_annotation.dart';

import '../../object/geo.dart';
import 'condition.dart';

part 'geo_point_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [Q] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class GeoPointConditionBuilder {
  GeoPointConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  GeoPointCondition equalTo(GeoPoint operand) {
    return GeoPointCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  GeoPointCondition notEqualTo(GeoPoint operand) {
    return GeoPointCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GeoPointCondition extends Condition<GeoPoint> {
  const GeoPointCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory GeoPointCondition.fromJson(Map<String, dynamic> json) =>
      _$GeoPointConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(GeoPoint value) {
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
  Map<String, dynamic> toJson() => _$GeoPointConditionToJson(this);

  @override
  GeoPointCondition withField(String field) {
    return GeoPointCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
