import 'package:precept_script/common/interpolate.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';
import 'package:precept_script/script/script.dart';

/// [VAL] is the validator type for example, [IntegerValidation]
/// [MODEL] is the data type of the model attribute represented
abstract class PField<VAL extends ModelValidation, MODEL> extends PSchemaElement {
  final List<VAL> validations;

  Type get modelType;

  PField({this.validations, Permissions permissions}) : super(permissions:permissions);

  /// Returns a list of validation errors, or an empty list if there are none
  List<String> validate(MODEL value, PScript pScript) {
    if (validations == null || validations.isEmpty) {
      return List();
    }
    final List<String> errors = List();
    for (VAL validation in validations) {
      bool failedValidation=!doValidation(validation, value);
      if(failedValidation){
        String errorMsg =pScript.validationErrorMessages.find(validation);
        if (errorMsg==null){
          errorMsg='error message not defined for ${validation.method}';
          logType(this.runtimeType).e(errorMsg);
        }
        errors.add(interpolate(errorMsg,[validation.param]));
      }
    }
    return errors;
  }

  bool doValidation(VAL validation, MODEL value);


}
