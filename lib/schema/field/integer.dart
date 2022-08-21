// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../data/select/condition/condition.dart';
import '../../script/script_element.dart';
import 'field.dart';

part 'integer.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FInteger extends Field<int> {
  FInteger({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FInteger.fromJson(Map<String, dynamic> json) =>
      _$FIntegerFromJson(json);

  @override
  Type get modelType => int;

  @override
  Map<String, dynamic> toJson() => _$FIntegerToJson(this);
}
