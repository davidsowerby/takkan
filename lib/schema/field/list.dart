import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'list.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PList extends PField<ListValidation, List> {
  PList({
    List<ListValidation> validations=const [],
    PPermissions permissions=const PPermissions(),
  }) : super(
          permissions: permissions,
          validations: validations,
        );

  factory PList.fromJson(Map<String, dynamic> json) => _$PListFromJson(json);

  Map<String, dynamic> toJson() => _$PListToJson(this);

  @override
  bool doValidation(ListValidation validation, List value) {
    // TODO: implement doValidation
    throw UnimplementedError();
  }

  @override
  Type get modelType => List;
}

enum ValidateList { containsLessThan, containsMoreThan }

@JsonSerializable(nullable: true, explicitToJson: true)
class ListValidation implements ModelValidation<ValidateList, List> {
  final ValidateList method;
  final int param;

  const ListValidation({@required this.method, this.param});

  factory ListValidation.fromJson(Map<String, dynamic> json) => _$ListValidationFromJson(json);

  Map<String, dynamic> toJson() => _$ListValidationToJson(this);
}
