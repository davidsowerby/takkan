import 'package:json_annotation/json_annotation.dart';

import '../../object/geo.dart';
import 'condition.dart';

part 'geo_position_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [Q] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class GeoPositionConditionBuilder {
  GeoPositionConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  GeoPositionCondition equalTo(GeoPosition operand) {
    return GeoPositionCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  GeoPositionCondition notEqualTo(GeoPosition operand) {
    return GeoPositionCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GeoPositionCondition extends Condition<GeoPosition> {
  const GeoPositionCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory GeoPositionCondition.fromJson(Map<String, dynamic> json) =>
      _$GeoPositionConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(GeoPosition value) {
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
  Map<String, dynamic> toJson() => _$GeoPositionConditionToJson(this);

  @override
  GeoPositionCondition withField(String field) {
    return GeoPositionCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
