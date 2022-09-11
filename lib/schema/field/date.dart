// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/select/condition/date_time_condition.dart';
import 'field.dart';

part 'date.g.dart';

@JsonSerializable(explicitToJson: true)
class FDate extends Field<DateTime, DateTimeCondition> {
  FDate({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FDate.fromJson(Map<String, dynamic> json) => _$FDateFromJson(json);

  @override
  Type get modelType => DateTime;

  @override
  Map<String, dynamic> toJson() => _$FDateToJson(this);
}
