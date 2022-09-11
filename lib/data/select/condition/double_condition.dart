import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'double_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [C] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class DoubleConditionBuilder {
  DoubleConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  DoubleCondition equalTo(double operand) {
    return DoubleCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  DoubleCondition notEqualTo(double operand) {
    return DoubleCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class DoubleCondition extends Condition<double> {
  const DoubleCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory DoubleCondition.fromJson(Map<String, dynamic> json) =>
      _$DoubleConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(double value) {
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
  Map<String, dynamic> toJson() => _$DoubleConditionToJson(this);

  @override
  DoubleCondition withField(String field) {
    return DoubleCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
