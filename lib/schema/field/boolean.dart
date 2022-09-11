// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/select/condition/bool_condition.dart';
import 'field.dart';

part 'boolean.g.dart';

@JsonSerializable(explicitToJson: true)
class FBoolean extends Field<bool, BoolCondition> {
  FBoolean({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FBoolean.fromJson(Map<String, dynamic> json) =>
      _$FBooleanFromJson(json);

  @override
  Type get modelType => bool;

  @override
  Map<String, dynamic> toJson() => _$FBooleanToJson(this);
}
