// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import '../../common/constants.dart';

import '../../data/select/condition/condition.dart';
import 'field.dart';

part 'list.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FList extends Field<List<dynamic>> {
  FList({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
  });

  factory FList.fromJson(Map<String, dynamic> json) => _$FListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FListToJson(this);

  @override
  Type get modelType => List;
}
