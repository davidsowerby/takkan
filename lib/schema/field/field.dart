import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/util/interpolate.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/validation/result.dart';
import 'package:takkan_script/validation/validate.dart';

/// [VAL] is the validator type for example, [IntegerValidation]
/// [MODEL] is the data type of the model attribute represented
///
abstract class Field<VAL, MODEL> extends SchemaElement {
  final List<VAL> validations;
  final bool required;
  @JsonKey(includeIfNull: false)
  final MODEL? defaultValue;

  Type get modelType;

  Field({
    this.validations = const [],
    required this.required,
    this.defaultValue,
    required super. readOnly,
  }) ;

  /// Returns a list of validation errors, or an empty list if there are none
  List<String> doValidation(MODEL value, Script pScript) {
    if (validations.isEmpty) {
      return List.empty();
    }
    final List<String> errors = List.empty(growable: true);
    for (final VAL validation in validations) {
      if (validation is V) {
        final VResult result = validate(validation, value);
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
