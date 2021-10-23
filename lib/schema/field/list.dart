import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'list.g.dart';

@JsonSerializable(explicitToJson: true)
class PList extends PField<ListValidation, List> {
  PList({
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

  factory PList.fromJson(Map<String, dynamic> json) => _$PListFromJson(json);

  Map<String, dynamic> toJson() => _$PListToJson(this);

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
