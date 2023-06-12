import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'integer_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [C] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class IntegerConditionBuilder {
  IntegerConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  IntegerCondition equalTo(int operand) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  IntegerCondition lessThan(int operand) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.lessThan,
      operand: operand,
      forQuery: forQuery,
    );
  }

  IntegerCondition lessThanOrEqualTo(int operand) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.lessThanOrEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  IntegerCondition notEqualTo(int operand) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  IntegerCondition greaterThan(int operand) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.greaterThan,
      operand: operand,
      forQuery: forQuery,
    );
  }

  IntegerCondition greaterThanOrEqualTo(int operand) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.greaterThanOrEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IntegerCondition extends Condition<int> {
  const IntegerCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory IntegerCondition.fromJson(Map<String, dynamic> json) =>
      _$IntegerConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(int value) {
    switch (operator) {
      case Operator.equalTo:
        return value == operand;
      case Operator.notEqualTo:
        return value != operand;
      case Operator.greaterThan:
        return value > typedOperand;
      case Operator.greaterThanOrEqualTo:
        return value >= typedOperand;
      case Operator.lessThan:
        return value < typedOperand;
      case Operator.lessThanOrEqualTo:
        return value <= typedOperand;
      default:
        return throwOperatorInvalid();
    }
  }

  @override
  List<Operator> get notValidForType => [...lengthOperations];

  @override
  Map<String, dynamic> toJson() => _$IntegerConditionToJson(this);

  @override
  IntegerCondition withField(String field) {
    return IntegerCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
