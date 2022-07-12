import 'package:json_annotation/json_annotation.dart';

import '../../../common/exception.dart';
import '../../../common/log.dart';
import 'condition.dart';

part 'string_condition.g.dart';

class StringConditionBuilder {
  StringConditionBuilder(this.fieldName);

  String fieldName;

  StringCondition equalTo(String reference) {
    return StringCondition(
      field: fieldName,
      operator: Operator.equalTo,
      reference: reference,
    );
  }

  StringCondition notEqualTo(String reference) {
    return StringCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      reference: reference,
    );
  }

  StringCondition longerThan(int reference) {
    return StringCondition(
      field: fieldName,
      operator: Operator.greaterThan,
      reference: reference,
    );
  }

  StringCondition shorterThan(int reference) {
    return StringCondition(
      field: fieldName,
      operator: Operator.lessThan,
      reference: reference,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class StringCondition extends Condition<String> {
  const StringCondition(
      {required super.field,
      required super.operator,
      required super.reference});

  factory StringCondition.fromJson(Map<String, dynamic> json) =>
      _$StringConditionFromJson(json);

  @override
  bool isValid(String value) {
    switch (operator) {
      case Operator.equalTo:
        return value == reference;
      case Operator.notEqualTo:
        return value != reference;
      case Operator.greaterThan:
        return value.length > (reference as int);
      case Operator.lessThan:
      case Operator.longerThan:
      case Operator.shorterThan:
        {
          final String msg =
              "Operator '${operator.name}' not implemented in $runtimeType";
          logType(runtimeType).e(msg);
          throw TakkanException(msg);
        }
    }
  }

  @override
  Map<String, dynamic> toJson() => _$StringConditionToJson(this);

  @override
  Condition<String> withField(String field) {
    return StringCondition(
        reference: reference, field: field, operator: operator);
  }
}
