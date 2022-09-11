// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/select/condition/list_int_condition.dart';
import 'field.dart';

part 'list.g.dart';

@JsonSerializable(explicitToJson: true)
class FIntegerList extends Field<List<int>, ListIntCondition> {
  FIntegerList({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
  });

  factory FIntegerList.fromJson(Map<String, dynamic> json) =>
      _$FIntegerListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FIntegerListToJson(this);

  @override
  Type get modelType => List;
}
