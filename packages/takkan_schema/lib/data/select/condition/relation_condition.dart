import 'package:json_annotation/json_annotation.dart';

import '../../object/relation.dart';
import 'condition.dart';

part 'relation_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [C] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class RelationConditionBuilder {
  RelationConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  RelationCondition equalTo(Relation operand) {
    return RelationCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  RelationCondition notEqualTo(Relation operand) {
    return RelationCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RelationCondition extends Condition<Relation> {
  const RelationCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory RelationCondition.fromJson(Map<String, dynamic> json) =>
      _$RelationConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(Relation value) {
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
  Map<String, dynamic> toJson() => _$RelationConditionToJson(this);

  @override
  RelationCondition withField(String field) {
    return RelationCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
