import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';

// part 'select.g.dart';

abstract class PSelectField extends PField {
  PSelectField({required bool required, required PPermissions permissions})
      : super(
          required: required,
          permissions: permissions,
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
