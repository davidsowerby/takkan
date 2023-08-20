import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'string_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [C] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class StringConditionBuilder {
  StringConditionBuilder({required this.fieldName, required this.forQuery});

  String fieldName;
  final bool forQuery;

  StringCondition equalTo(String operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition notEqualTo(String operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition lengthGreaterThan(int operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.lengthGreaterThan,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition lengthGreaterThanOrEqualTo(int operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.lengthGreaterThanOrEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition lengthLessThan(int operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.lengthLessThan,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition lengthLessThanOrEqualTo(int operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.lengthLessThanOrEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition lessThan(String operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.lessThan,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition lessThanOrEqualTo(String operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.lessThanOrEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition greaterThan(String operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.greaterThan,
      operand: operand,
      forQuery: forQuery,
    );
  }

  StringCondition greaterThanOrEqualTo(String operand) {
    return StringCondition(
      field: fieldName,
      operator: Operator.greaterThanOrEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class StringCondition extends Condition<String> {
  const StringCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory StringCondition.fromJson(Map<String, dynamic> json) =>
      _$StringConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(String value) {
    switch (operator) {
      case Operator.equalTo:
        return value == operand;
      case Operator.lessThan:
        return value.compareTo(typedOperand) < 0;
      case Operator.notEqualTo:
        return value != operand;
      case Operator.greaterThanOrEqualTo:
        return value.compareTo(typedOperand) >= 0;
      case Operator.lengthGreaterThanOrEqualTo:
        return value.length >= (operand as int);
      case Operator.lengthLessThan:
        return value.length < (operand as int);
      case Operator.lengthGreaterThan:
        return value.length > (operand as int);
      case Operator.greaterThan:
        return value.compareTo(typedOperand) > 0;
      case Operator.lessThanOrEqualTo:
        return value.compareTo(typedOperand) <= 0;
      case Operator.lengthLessThanOrEqualTo:
        return value.length <= (operand as int);
      default:
        return throwOperatorInvalid();
    }
  }

  @override
  Map<String, dynamic> toJson() => _$StringConditionToJson(this);

  @override
  Condition<String> withField(String field) {
    return StringCondition(
      operand: operand,
      field: field,
      operator: operator,
      forQuery: forQuery,
    );
  }
}
