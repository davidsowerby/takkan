import 'package:json_annotation/json_annotation.dart';
import '../../../common/exception.dart';
import '../../../common/log.dart';

import 'condition.dart';

part 'integer_condition.g.dart';

class IntegerConditionBuilder {
  IntegerConditionBuilder(this.fieldName);

  String fieldName;

  IntegerCondition equalTo(int reference) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.equalTo,
      reference: reference,
    );
  }

  IntegerCondition lessThan(int reference) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.lessThan,
      reference: reference,
    );
  }

  IntegerCondition notEqualTo(int reference) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.notEqualTo,
      reference: reference,
    );
  }

  IntegerCondition greaterThan(int reference) {
    return IntegerCondition(
      field: fieldName,
      operator: Operator.greaterThan,
      reference: reference,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IntegerCondition extends Condition<int> {
  const IntegerCondition(
      {required super.field,
      required super.operator,
      required super.reference});

  factory IntegerCondition.fromJson(Map<String, dynamic> json) =>
      _$IntegerConditionFromJson(json);

  @override
  bool isValid(int value) {
    switch (operator) {
      case Operator.equalTo:
        return value == reference;
      case Operator.notEqualTo:
        return value != reference;
      case Operator.greaterThan:
        return value > (reference as int);
      case Operator.lessThan:
        return value < (reference as int);

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
  Map<String, dynamic> toJson() => _$IntegerConditionToJson(this);

  @override
  IntegerCondition withField(String field) {
    return IntegerCondition(
        field: field, operator: operator, reference: reference);
  }
}
