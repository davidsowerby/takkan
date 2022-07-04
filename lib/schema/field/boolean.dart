import 'package:json_annotation/json_annotation.dart';
import '../../data/select/condition/condition.dart';
import '../../script/common.dart';
import 'field.dart';

part 'boolean.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FBoolean extends Field< bool> {
  FBoolean({
    super.defaultValue,
    super. constraints = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
    super.validation,
  }) ;

  factory FBoolean.fromJson(Map<String, dynamic> json) =>
      _$FBooleanFromJson(json);

  @override
  Type get modelType => bool;

  @override
  Map<String, dynamic> toJson() => _$FBooleanToJson(this);
}
