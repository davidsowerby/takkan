// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/object/json_object.dart';
import '../../data/select/condition/json_object_condition.dart';
import 'field.dart';

part 'object.g.dart';

/// An embedded JSON object
@JsonSerializable(explicitToJson: true)
class FObject extends Field<JsonObject, JsonObjectCondition> {
  FObject({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FObject.fromJson(Map<String, dynamic> json) =>
      _$FObjectFromJson(json);

  @override
  Type get modelType => JsonObject;

  @override
  Map<String, dynamic> toJson() => _$FObjectToJson(this);
}
