import 'package:precept_script/schema/field/integer.dart';

String integerFunction(ValidateInteger validateInteger) {
  switch (validateInteger) {
    case ValidateInteger.isGreaterThan:
      return 'value > param';
    case ValidateInteger.isLessThan:
      return 'value < param';
  }
}
