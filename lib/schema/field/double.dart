// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/select/condition/double_condition.dart';
import 'field.dart';

part 'double.g.dart';

@JsonSerializable(explicitToJson: true)
class FDouble extends Field<double, DoubleCondition> {
  FDouble({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FDouble.fromJson(Map<String, dynamic> json) =>
      _$FDoubleFromJson(json);

  @override
  Type get modelType => double;

  @override
  Map<String, dynamic> toJson() => _$FDoubleToJson(this);
}
