import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'list.g.dart';

@JsonSerializable(explicitToJson: true)
class FList extends Field<ListValidation, List> {
  FList({
    List<ListValidation> validations = const [],
    bool required = false,
    List? defaultValue,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
          readOnly: readOnly,
          defaultValue: defaultValue,
          required: required,
          validations: validations,
        );

  factory FList.fromJson(Map<String, dynamic> json) => _$FListFromJson(json);

  Map<String, dynamic> toJson() => _$FListToJson(this);

  @override
  Type get modelType => List;
}

enum ValidateList { containsLessThan, containsMoreThan }

@JsonSerializable(explicitToJson: true)
class ListValidation implements ModelValidation<ValidateList, List> {
  final ValidateList method;
  final int param;

  const ListValidation({required this.method, this.param = 0});

  factory ListValidation.fromJson(Map<String, dynamic> json) =>
      _$ListValidationFromJson(json);

  Map<String, dynamic> toJson() => _$ListValidationToJson(this);
}
