import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'list_int_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [Q] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class ListIntConditionBuilder {
  ListIntConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  ListIntCondition equalTo(List<int> operand) {
    return ListIntCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  ListIntCondition notEqualTo(List<int> operand) {
    return ListIntCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ListIntCondition extends Condition<List<int>> {
  const ListIntCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory ListIntCondition.fromJson(Map<String, dynamic> json) =>
      _$ListIntConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(List<int> value) {
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
  Map<String, dynamic> toJson() => _$ListIntConditionToJson(this);

  @override
  ListIntCondition withField(String field) {
    return ListIntCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
