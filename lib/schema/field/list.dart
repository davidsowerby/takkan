import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'list.g.dart';

@JsonSerializable(explicitToJson: true)
class FList extends Field<ListValidation, List> {
  FList({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  factory FList.fromJson(Map<String, dynamic> json) => _$FListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FListToJson(this);

  @override
  Type get modelType => List;
}

enum ValidateList { containsLessThan, containsMoreThan }

@JsonSerializable(explicitToJson: true)
class ListValidation implements ModelValidation<ValidateList, List> {
  @override
  final ValidateList method;
  @override
  final int param;

  const ListValidation({required this.method, this.param = 0});

  factory ListValidation.fromJson(Map<String, dynamic> json) =>
      _$ListValidationFromJson(json);

  Map<String, dynamic> toJson() => _$ListValidationToJson(this);
}
