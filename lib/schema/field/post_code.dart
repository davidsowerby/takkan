// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/object/post_code.dart';
import '../../data/select/condition/post_code_condition.dart';
import 'field.dart';

part 'post_code.g.dart';

@JsonSerializable(explicitToJson: true)
class FPostCode extends Field<PostCode, PostCodeCondition> {
  FPostCode({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FPostCode.fromJson(Map<String, dynamic> json) =>
      _$FPostCodeFromJson(json);

  @override
  Type get modelType => PostCode;

  @override
  Map<String, dynamic> toJson() => _$FPostCodeToJson(this);
}
