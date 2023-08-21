import 'package:json_annotation/json_annotation.dart';

import '../../object/json_object.dart';
import 'condition.dart';

part 'json_object_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [Q] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class JsonObjectConditionBuilder {
  JsonObjectConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  JsonObjectCondition equalTo(JsonObject operand) {
    return JsonObjectCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  JsonObjectCondition notEqualTo(JsonObject operand) {
    return JsonObjectCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JsonObjectCondition extends Condition<JsonObject> {
  const JsonObjectCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory JsonObjectCondition.fromJson(Map<String, dynamic> json) =>
      _$JsonObjectConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(JsonObject value) {
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
  Map<String, dynamic> toJson() => _$JsonObjectConditionToJson(this);

  @override
  JsonObjectCondition withField(String field) {
    return JsonObjectCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
