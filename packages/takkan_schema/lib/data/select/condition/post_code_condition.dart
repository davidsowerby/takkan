import 'package:json_annotation/json_annotation.dart';

import '../../object/post_code.dart';
import 'condition.dart';

part 'post_code_condition.g.dart';

/// The only real purpose of this class is to support IDE friendly definitions of
/// query and validation conditions, using [C] and [V] respectively.
///
/// The [fieldName] cannot be final as it may need updating when used in validation
class PostCodeConditionBuilder {
  PostCodeConditionBuilder({
    required this.fieldName,
    required this.forQuery,
  });

  String fieldName;
  final bool forQuery;

  PostCodeCondition equalTo(PostCode operand) {
    return PostCodeCondition(
      field: fieldName,
      operator: Operator.equalTo,
      operand: operand,
      forQuery: forQuery,
    );
  }

  PostCodeCondition notEqualTo(PostCode operand) {
    return PostCodeCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      operand: operand,
      forQuery: forQuery,
    );
  }


}

@JsonSerializable(explicitToJson: true)
class PostCodeCondition extends Condition<PostCode> {
  const PostCodeCondition({
    required super.field,
    required super.operator,
    required super.operand,
    required super.forQuery,
  });

  factory PostCodeCondition.fromJson(Map<String, dynamic> json) =>
      _$PostCodeConditionFromJson(json);

  /// Call inherited method [isValid] rather than directly accessing this method
  @override
  bool typedOperations(PostCode value) {
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
  Map<String, dynamic> toJson() => _$PostCodeConditionToJson(this);

  @override
  PostCodeCondition withField(String field) {
    return PostCodeCondition(
        field: field, operator: operator, operand: operand, forQuery: forQuery);
  }
}
