import 'package:json_annotation/json_annotation.dart';

import '../../data/select/condition/condition.dart';
import '../../script/common.dart';
import 'field.dart';

part 'date.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FDate extends Field< DateTime> {

  FDate({
    super. defaultValue,
    super.constraints = const [],
    super.required = false,
    super. readOnly = IsReadOnly.inherited,
    super.validation,
  }) ;

  factory FDate.fromJson(Map<String, dynamic> json) => _$FDateFromJson(json);
  @override
  Type get modelType => DateTime;

  @override
  Map<String, dynamic> toJson() => _$FDateToJson(this);
}
