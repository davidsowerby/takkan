// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/select/condition/integer_condition.dart';
import 'field.dart';

part 'integer.g.dart';

@JsonSerializable(explicitToJson: true)
class FInteger extends Field<int, IntegerCondition> {
  FInteger({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FInteger.fromJson(Map<String, dynamic> json) =>
      _$FIntegerFromJson(json);

  @override
  Type get modelType => int;

  @override
  Map<String, dynamic> toJson() => _$FIntegerToJson(this);
}
