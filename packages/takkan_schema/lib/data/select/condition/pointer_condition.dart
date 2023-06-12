import 'package:json_annotation/json_annotation.dart';

import '../../object/pointer.dart';
import 'condition.dart';

part 'pointer_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [C] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class PointerConditionBuilder {
  PointerConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  PointerCondition equalTo(Pointer operand) {
    return PointerCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  PointerCondition notEqualTo(Pointer operand) {
    return PointerCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PointerCondition extends Condition<Pointer> {
  const PointerCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory PointerCondition.fromJson(Map<String, dynamic> json) =>
      _$PointerConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(Pointer value) {
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
  Map<String, dynamic> toJson() => _$PointerConditionToJson(this);

  @override
  PointerCondition withField(String field) {
    return PointerCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
