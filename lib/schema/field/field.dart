import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/util/interpolate.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';
import 'package:precept_script/script/script.dart';
/// [VAL] is the validator type for example, [IntegerValidation]
/// [MODEL] is the data type of the model attribute represented
///
abstract class PField<VAL extends ModelValidation, MODEL> extends PSchemaElement {
  final List<VAL> validations;
  final PPermissions? permissions;
  final bool required;
  @JsonKey(includeIfNull: false)
  final MODEL? defaultValue;

  Type get modelType;

  PField({
    this.validations = const [],
    this.permissions,
    required this.required,
    this.defaultValue,
  }) : super();

  /// Returns a list of validation errors, or an empty list if there are none
  List<String> validate(MODEL value, PScript pScript) {
    if (validations.isEmpty) {
      return List.empty();
    }
    final List<String> errors = List.empty(growable: true);
    for (VAL validation in validations) {
      bool failedValidation = !doValidation(validation, value);
      if (failedValidation) {
        String? errorMsg = pScript.validationErrorMessages.find(validation);
        if (errorMsg == null) {
          errorMsg = 'error message not defined for ${validation.method}';
          logType(this.runtimeType).e(errorMsg);
        }
        errors.add(expandErrorMessage(errorMsg, [validation.param]));
      }
    }
    return errors;
  }

  bool doValidation(VAL validation, MODEL value);
}
