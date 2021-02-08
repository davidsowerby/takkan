import 'package:validators/validators.dart';

validateString(Validation validation, String value) {
  switch (validation) {
    case Validation.isAlpha:
      return isAlpha(value);
    case Validation.isInt:
      return isInt(value);
      break;
  }
}

String validationMessage(Validation validation, dynamic value,
    {List<dynamic> params = const []}) {
  final pattern = validationPattern(validation);
  return interpolate(pattern, params);
}

/// This is temporary, it should be a lookup from something sent by the server as part of the PScript
String validationPattern(Validation validation) {
  assert(validation != null);
  switch (validation) {
    case Validation.isAlpha:
      return 'must be all letters';
    case Validation.isInt:
      return 'must be a whole number';
  }
  return null; // unreachable
}

abstract class Validator<T> {
  String validate(T value);
}

String interpolate(String pattern, List<dynamic> params) {
  int count = 0;
  String result = pattern;
  for (var param in params) {
    result = pattern.replaceFirst('{$count}', param.toString());
    count++;
  }
  return result;
}

class StringValidator implements Validator<String> {
  final List<Validation> validations;

  const StringValidator({this.validations = const []});

  String validate(String value) {
    final StringBuffer buf = StringBuffer();
    int count = 0;
    for (Validation validation in validations) {
      final bool isValid = validateString(validation, value);
      if (!isValid) {
        final message = validationMessage(validation, value);
        if (count > 0) buf.write(';');
        buf.write(message);
        count++;
      }
    }
    return buf.toString();
  }
}

enum Validation { isAlpha, isInt }
