import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'date_time_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [C] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class DateTimeConditionBuilder {
  DateTimeConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  DateTimeCondition equalTo(DateTime operand) {
    return DateTimeCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  DateTimeCondition notEqualTo(DateTime operand) {
    return DateTimeCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class DateTimeCondition extends Condition<DateTime> {
  const DateTimeCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory DateTimeCondition.fromJson(Map<String, dynamic> json) =>
      _$DateTimeConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(DateTime value) {
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
  Map<String, dynamic> toJson() => _$DateTimeConditionToJson(this);

  @override
  DateTimeCondition withField(String field) {
    return DateTimeCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
