import 'package:precept_script/schema/field/integer.dart';

String integerValidation(
    {required String fieldName, required IntegerValidation validation}) {
  switch (validation.method) {
    case ValidateInteger.isGreaterThan:
      return 'object.get(\"$fieldName\") > ${validation.param}';
    case ValidateInteger.isLessThan:
      return 'object.get(\"$fieldName\") < ${validation.param}';
  }
}
