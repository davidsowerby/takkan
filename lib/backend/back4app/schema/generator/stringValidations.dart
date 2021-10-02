import 'package:precept_script/schema/field/string.dart';

String stringFunctionCode(ValidateString validateString) {
  switch (validateString) {
    case ValidateString.alpha:
      return 'val.isAlpha(param)';
    case ValidateString.contains:
      return 'val.contains(param)';
    case ValidateString.lengthEquals:
      return 'value.length == param';
    case ValidateString.lengthGreaterThan:
      return 'value.length > param';
    case ValidateString.lengthLessThan:
      return 'value.length < param';
  }
}
