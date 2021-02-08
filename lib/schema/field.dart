import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/geoPosition.dart';
import 'package:precept_script/data/postCode.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'field.g.dart';

abstract class PField extends PSchemaElement {
  final List<Validation> validation;

  PField({this.validation});
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PBoolean extends PField {
  final bool defaultValue;

  PBoolean({this.defaultValue, List<Validation> validation}) : super(validation: validation);

  factory PBoolean.fromJson(Map<String, dynamic> json) => _$PBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$PBooleanToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PInteger extends PField {
  final int defaultValue;

  PInteger({this.defaultValue, List<Validation> validation}) : super(validation: validation);

  factory PInteger.fromJson(Map<String, dynamic> json) => _$PIntegerFromJson(json);

  Map<String, dynamic> toJson() => _$PIntegerToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PField {
  final String defaultValue;

  PString({this.defaultValue, List<Validation> validation}) : super(validation: validation);

  factory PString.fromJson(Map<String, dynamic> json) => _$PStringFromJson(json);

  Map<String, dynamic> toJson() => _$PStringToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PDate extends PField {
  final DateTime defaultValue;

  PDate({this.defaultValue, List<Validation> validation}) : super(validation: validation);

  factory PDate.fromJson(Map<String, dynamic> json) => _$PDateFromJson(json);

  Map<String, dynamic> toJson() => _$PDateToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPointer extends PField {
  PPointer({ List<Validation> validation}) : super(validation: validation);

  factory PPointer.fromJson(Map<String, dynamic> json) => _$PPointerFromJson(json);

  Map<String, dynamic> toJson() => _$PPointerToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PDouble extends PField {
  final double defaultValue;

  PDouble({this.defaultValue = 0.0, List<Validation> validation}) : super(validation: validation);

  factory PDouble.fromJson(Map<String, dynamic> json) => _$PDoubleFromJson(json);

  Map<String, dynamic> toJson() => _$PDoubleToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoPosition extends PField {
  final GeoPosition defaultValue;

  PGeoPosition({this.defaultValue, List<Validation> validation}) : super(validation: validation);

  factory PGeoPosition.fromJson(Map<String, dynamic> json) => _$PGeoPositionFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPositionToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPostCode extends PField {
  final PostCode defaultValue;

  PPostCode({this.defaultValue, List<Validation> validation}) : super(validation: validation);

  factory PPostCode.fromJson(Map<String, dynamic> json) => _$PPostCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PPostCodeToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoLocation extends PField {
  final GeoLocation defaultValue;

  PGeoLocation({this.defaultValue, List<Validation> validation}) : super(validation: validation);

  factory PGeoLocation.fromJson(Map<String, dynamic> json) => _$PGeoLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoLocationToJson(this);
}
