import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/object/post_code.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';
import 'package:validators/validators.dart';

part 'post_code.g.dart';

@JsonSerializable(explicitToJson: true)
class PPostCode extends PField<PostCodeValidation, PostCode> {
  Type get modelType => PostCode;

  PPostCode({
    PostCode? defaultValue,
    List<PostCodeValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
    readOnly: readOnly,
          defaultValue: defaultValue,
          required: required,
          validations: validations,
        );

  factory PPostCode.fromJson(Map<String, dynamic> json) =>
      _$PPostCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PPostCodeToJson(this);
}

// TODO change this to the freezed method of VInteger / VString
@JsonSerializable(explicitToJson: true)
class PostCodeValidation
    implements ModelValidation<ValidatePostCode, PostCode> {
  final ValidatePostCode method;
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
