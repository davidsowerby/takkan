import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/object/post_code.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';
import 'package:validators/validators.dart';

part 'post_code.g.dart';

@JsonSerializable(explicitToJson: true)
class FPostCode extends Field<PostCodeValidation, PostCode> {
  @override
  Type get modelType => PostCode;

  FPostCode({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  factory FPostCode.fromJson(Map<String, dynamic> json) =>
      _$FPostCodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FPostCodeToJson(this);
}

// TODO change this to the freezed method of VInteger / VString
@JsonSerializable(explicitToJson: true)
class PostCodeValidation
    implements ModelValidation<ValidatePostCode, PostCode> {
  @override
  final ValidatePostCode method;
  @override
  final PostCode? param;

  const PostCodeValidation({required this.method, this.param});

  factory PostCodeValidation.fromJson(Map<String, dynamic> json) =>
      _$PostCodeValidationFromJson(json);

  Map<String, dynamic> toJson() => _$PostCodeValidationToJson(this);
}

enum ValidatePostCode { isValidForLocale }

validatePostCode(PostCodeValidation validation, PostCode value) {
  switch (validation.method) {
    case ValidatePostCode.isValidForLocale:
      throw UnimplementedError();
  }
}

bool isValidFor(PostCode value, String locale) {
  return isPostalCode(value.postCode, locale);
}
