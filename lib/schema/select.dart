import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';

// part 'select.g.dart';

abstract class PSelectField extends PField {
  PSelectField({
    IsReadOnly readOnly = IsReadOnly.inherited,
    required bool required,
  }) : super(
    readOnly: readOnly,
          required: required,
        );
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
