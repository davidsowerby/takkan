import 'package:json_annotation/json_annotation.dart';

import '../../data/object/post_code.dart';
import '../../data/select/condition/condition.dart';
import '../../script/common.dart';
import 'field.dart';

part 'post_code.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FPostCode extends Field<PostCode> {
  FPostCode({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FPostCode.fromJson(Map<String, dynamic> json) =>
      _$FPostCodeFromJson(json);

  @override
  Type get modelType => PostCode;

  @override
  Map<String, dynamic> toJson() => _$FPostCodeToJson(this);
}
