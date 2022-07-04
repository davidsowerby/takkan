
import '../../data/select/condition/condition.dart';

/// This is a temporary setup until the validation patterns can be included in PScript,
/// or some other server based method is designed
///
class ValidationErrorMessages {

  const ValidationErrorMessages({this.typePatterns = const {}});
  final Map<Object, String> typePatterns;

  String? find(Operator patternKey) {
    return typePatterns[patternKey];
  }

  bool get isEmpty => typePatterns.isEmpty;
}

const Map<Object, String> defaultValidationErrorMessages = {
  Operator.greaterThan: 'must be greater than {threshold}',
  Operator.lessThan: 'must be less than {threshold}',
  Operator.longerThan: 'must have length of more than {threshold}',
  Operator.shorterThan: 'must have length of less than {threshold} characters',
};
