// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../data/select/condition/condition.dart';
import '../../script/script_element.dart';
import '../../script/takkan_element.dart';
import 'field.dart';

part 'string.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FString extends Field<String> {
  FString({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FString.fromJson(Map<String, dynamic> json) =>
      _$FStringFromJson(json);

  @override
  Type get modelType => String;

  @override
  Map<String, dynamic> toJson() => _$FStringToJson(this);
}
