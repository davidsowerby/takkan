// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import '../common/constants.dart';

import 'field/field.dart';

// part 'select.g.dart';

abstract class SelectField extends Field<dynamic> {
  SelectField({
    super.readOnly = IsReadOnly.inherited,
    required super.required,
  });
}

// @JsonSerializable( explicitToJson: true)
// class PSelectBoolean extends PSelectField {
//   final List<bool> defaultValue;
//
//    PSelectBoolean({this.defaultValue=const []}) ;
//
//   factory PSelectBoolean.fromJson(Map<String, dynamic> json) =>
//       _$PSelectBooleanFromJson(json);
//
//   Map<String, dynamic> toJson() => _$PSelectBooleanToJson(this);
//
//   @override
//   Type get modelType => bool;
// }
//
// @JsonSerializable( explicitToJson: true)
// class PSelectString extends PSelectField {
//
//   final List<String> defaultValue;
//
//    PSelectString({this.defaultValue}) ;
//
//   factory PSelectString.fromJson(Map<String, dynamic> json) =>
//       _$PSelectStringFromJson(json);
//
//   Map<String, dynamic> toJson() => _$PSelectStringToJson(this);
//
//   @override
//   Type get modelType => String;
// }
