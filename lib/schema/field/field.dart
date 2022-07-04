import 'package:json_annotation/json_annotation.dart';

import '../../common/log.dart';
import '../../script/script.dart';
import '../../util/interpolate.dart';
import '../../validation/result.dart';
import '../../validation/validate.dart';
import '../schema.dart';
import 'integer.dart';

/// [VAL] is the validator type for example, [IntegerValidation]
/// [MODEL] is the data type of the model attribute represented
///
abstract class Field<VAL, MODEL> extends SchemaElement {

  Field({
    this.validations = const [],
    required this.required,
    this.defaultValue,
    required super. readOnly,
  }) ;
  final List<VAL> validations;
  final bool required;
  @JsonKey(includeIfNull: false)
  final MODEL? defaultValue;

  Type get modelType;

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
            logType(runtimeType).e(errorPattern);
          } else {
            errors.add(expandErrorMessage(errorPattern, result.params));
          }
        }
      }
    }
    return errors;
  }



}
