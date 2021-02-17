import 'package:precept_script/schema/field/integer.dart';


/// [METHOD] is the method as described by an enum, for example, [ValidateInteger]
/// [MODEL] is the data type being validated
abstract class ModelValidation<METHOD,MODEL> {
  METHOD get method;
  dynamic get param;
}
