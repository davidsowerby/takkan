import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/util/interpolate.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/result.dart';
import 'package:precept_script/validation/validate.dart';

/// [VAL] is the validator type for example, [IntegerValidation]
/// [MODEL] is the data type of the model attribute represented
///
abstract class PField<VAL, MODEL> extends PSchemaElement {
  final List<VAL> validations;
  final bool required;
  @JsonKey(includeIfNull: false)
  final MODEL? defaultValue;

  Type get modelType;

  PField({
    this.validations = const [],
    required this.required,
    this.defaultValue,
    required IsReadOnly readOnly,
  }) : super(readOnly: readOnly);

  /// Returns a list of validation errors, or an empty list if there are none
  List<String> doValidation(MODEL value, PScript pScript) {
    if (validations.isEmpty) {
      return List.empty();
    }
    final List<String> errors = List.empty(growable: true);
    for (VAL validation in validations) {
      if (validation is V) {
        VResult result = validate(validation, value);
        if (result.failed) {
          String? errorPattern =
              pScript.validationErrorMessages.find(result.patternKey);
          if (errorPattern == null) {
            errorPattern = 'error message not defined for ${result.patternKey}';
            logType(this.runtimeType).e(errorPattern);
          } else {
            errors.add(expandErrorMessage(errorPattern, result.params));
          }
        }
      }
    }
    return errors;
  }

}
