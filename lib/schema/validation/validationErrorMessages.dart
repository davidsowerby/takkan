import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/validation/validator.dart';


/// This is a temporary setup until the validation patterns can be included in PScript,
/// or some other server based method is designed
///
class ValidationErrorMessages {
  final Map<dynamic, String> typePatterns;

  const ValidationErrorMessages({this.typePatterns=const {}});


  String? find(ModelValidation validation){
    return typePatterns[validation.method];
  }
}

const Map<dynamic, String> defaultValidationErrorMessages = const {
  ValidateInteger.isGreaterThan: 'must be greater than {0}',
  ValidateInteger.isLessThan: 'must be less than {0}',
  ValidateString.isLongerThan: 'must be more than {0} characters',
  ValidateString.isShorterThan: 'must be less than {0} characters',
};
