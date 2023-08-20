import 'package:equatable/equatable.dart';

import '../../data/select/condition/condition.dart';

/// This is a temporary setup until the validation patterns can be included in PScript,
/// or some other server based method is designed
///
class ValidationErrorMessages extends Equatable {
  const ValidationErrorMessages({this.typePatterns = const {}});
  final Map<Object, String> typePatterns;

  String? find(Operator patternKey) {
    return typePatterns[patternKey];
  }

  bool get isEmpty => typePatterns.isEmpty;

  @override
  // TODO: implement props
  List<Object?> get props => [typePatterns];
}

const Map<Object, String> defaultValidationErrorMessages = {
  Operator.equalTo: 'must be equal to {threshold}',
  Operator.lengthGreaterThan: 'must have length of greater than {threshold}',
  Operator.lengthGreaterThanOrEqualTo:
      'must have length of greater than or equal to {threshold}',
  Operator.lengthLessThan: 'must have length of less than {threshold}',
  Operator.lengthLessThanOrEqualTo:
      'must have length of less than or equal to {threshold}',
  Operator.greaterThan: 'must be greater than {threshold}',
  Operator.greaterThanOrEqualTo: 'must be greater than or equal to {threshold}',
  Operator.lessThan: 'must be less than {threshold}',
  Operator.lessThanOrEqualTo: 'must be less than or equal to {threshold}',
  Operator.notEqualTo: 'must not be equal to {threshold}',
};
