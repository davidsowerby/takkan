import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'bool_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [Q] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class BoolConditionBuilder {
  BoolConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  BoolCondition equalTo(bool operand) {
    return BoolCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  BoolCondition notEqualTo(bool operand) {
    return BoolCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class BoolCondition extends Condition<bool> {
  const BoolCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory BoolCondition.fromJson(Map<String, dynamic> json) =>
      _$BoolConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(bool value) {
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
  Map<String, dynamic> toJson() => _$BoolConditionToJson(this);

  @override
  BoolCondition withField(String field) {
    return BoolCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
