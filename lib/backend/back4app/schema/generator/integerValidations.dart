import 'package:precept_script/schema/field/integer.dart';

String integerFunctionCode(ValidateInteger validateInteger) {
  switch (validateInteger) {
    case ValidateInteger.greaterThan:
      return 'value > param';
    case ValidateInteger.lessThan:
      return 'value < param';
  }
}
