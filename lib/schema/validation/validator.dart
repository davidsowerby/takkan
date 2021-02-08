import 'package:flutter/foundation.dart';
import 'package:precept_script/schema/field.dart';
import 'package:validators/validators.dart';

validateString(Validation validation, String value) {
  switch (validation) {
    case Validation.isAlpha:
      return isAlpha(value);
    case Validation.isInt:
      return isInt(value);
    case Validation.isDouble:
      return isFloat(value);
  }
}

String validationMessage(Validation validation, dynamic value, {List<dynamic> params = const []}) {
  final pattern = validationFailPattern(validation);
  return interpolate(pattern, params);
}

/// This is temporary, it should be a lookup from something sent by the server as part of the PScript
String validationFailPattern(Validation validation) {
  assert(validation != null);
  switch (validation) {
    case Validation.isAlpha:
      return 'must be all letters';
    case Validation.isInt:
      return 'must be a whole number';
    case Validation.isDouble:
      return 'must be a number';
  }
  return null; // unreachable
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

class FieldValidator<MODEL> {
  final PField field;

  const FieldValidator({@required this.field}) : assert(field != null);

  String validate(MODEL value) {
    final StringBuffer buf = StringBuffer();
    int count = 0;
    for (Validation validation in field.validations) {
      final bool isValid = callValidation(validation, value);
      if (!isValid) {
        final message = validationMessage(validation, value);
        if (count > 0) buf.write(';');
        buf.write(message);
        count++;
      }
    }
    return buf.toString();
  }

  bool callValidation(Validation validation, dynamic value) {
    switch (field.modelType) {
      case String:
        return validateString(validation, value);
      default:
        throw UnimplementedError();
    }
  }
}

class ListValidator {}

enum Validation { isAlpha, isInt, isDouble }
