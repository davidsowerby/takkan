import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/schema/field/field.dart';

import '../../data/select/condition/condition.dart';

part 'double.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FDouble extends Field< double> {

  FDouble({
    super.defaultValue,
    super. constraints = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FDouble.fromJson(Map<String, dynamic> json) =>
      _$FDoubleFromJson(json);
  @override
  Type get modelType => double;

  @override
  Map<String, dynamic> toJson() => _$FDoubleToJson(this);
}
