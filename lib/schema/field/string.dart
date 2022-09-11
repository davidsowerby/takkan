// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/select/condition/string_condition.dart';
import 'field.dart';

part 'string.g.dart';

@JsonSerializable(explicitToJson: true)
class FString extends Field<String, StringCondition> {
  FString({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FString.fromJson(Map<String, dynamic> json) =>
      _$FStringFromJson(json);

  @override
  Type get modelType => String;

  @override
  Map<String, dynamic> toJson() => _$FStringToJson(this);
}
