import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';

/// This is a temporary setup until the validation patterns can be included in PScript,
/// or some other server based method is designed
///
class ValidationErrorMessages {
  final Map<Object, String> typePatterns;

  const ValidationErrorMessages({this.typePatterns = const {}});

  String? find(Object patternKey) {
    return typePatterns[patternKey];
  }
}

const Map<Object, String> defaultValidationErrorMessages = {
  IntegerValidation.greaterThan: 'must be greater than {threshold}',
  IntegerValidation.lessThan: 'must be less than {threshold}',
  StringValidation.longerThan: 'must be more than {threshold} characters',
  StringValidation.shorterThan: 'must be less than {threshold} characters',
};

// ValidateInteger.lessThan: 'must be less than {0}',
// ValidateString.lengthGreaterThan: 'must be more than {0} characters',
// ValidateString.lengthLessThan: 'must be less than {0} characters',
