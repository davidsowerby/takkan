// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../data/select/condition/condition.dart';
import '../../script/script_element.dart';
import 'field.dart';

part 'date.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FDate extends Field<DateTime> {
  FDate({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FDate.fromJson(Map<String, dynamic> json) => _$FDateFromJson(json);

  @override
  Type get modelType => DateTime;

  @override
  Map<String, dynamic> toJson() => _$FDateToJson(this);
}
