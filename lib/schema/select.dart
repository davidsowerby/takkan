import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field.dart';

part 'select.g.dart';

abstract class PSelectField extends PField{}

@JsonSerializable(nullable: true, explicitToJson: true)
class PSelectBoolean extends PSelectField {
  final List<bool> defaultValue;

   PSelectBoolean({this.defaultValue=const []}) ;

  factory PSelectBoolean.fromJson(Map<String, dynamic> json) =>
      _$PSelectBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$PSelectBooleanToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PSelectString extends PSelectField {

  final List<String> defaultValue;

   PSelectString({this.defaultValue}) ;

  factory PSelectString.fromJson(Map<String, dynamic> json) =>
      _$PSelectStringFromJson(json);

  Map<String, dynamic> toJson() => _$PSelectStringToJson(this);
}