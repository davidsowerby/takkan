import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/geoPosition.dart';
import 'package:precept_script/data/postCode.dart';
import 'package:precept_script/schema/schema.dart';

part 'field.g.dart';

abstract class PField extends PSchemaElement {}

@JsonSerializable(nullable: true, explicitToJson: true)
class PBoolean extends PField {
  final bool defaultValue;

  PBoolean({this.defaultValue});

  factory PBoolean.fromJson(Map<String, dynamic> json) => _$PBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$PBooleanToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PInteger extends PField {
  final int defaultValue;

  PInteger({this.defaultValue});

  factory PInteger.fromJson(Map<String, dynamic> json) => _$PIntegerFromJson(json);

  Map<String, dynamic> toJson() => _$PIntegerToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PField {
  final String defaultValue;

  PString({this.defaultValue});

  factory PString.fromJson(Map<String, dynamic> json) => _$PStringFromJson(json);

  Map<String, dynamic> toJson() => _$PStringToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PDate extends PField {
  final DateTime defaultValue;

  PDate({this.defaultValue});

  factory PDate.fromJson(Map<String, dynamic> json) => _$PDateFromJson(json);

  Map<String, dynamic> toJson() => _$PDateToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPointer extends PField {
  PPointer();

  factory PPointer.fromJson(Map<String, dynamic> json) => _$PPointerFromJson(json);

  Map<String, dynamic> toJson() => _$PPointerToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PDouble extends PField {
  final double defaultValue;

  PDouble({this.defaultValue = 0.0});

  factory PDouble.fromJson(Map<String, dynamic> json) => _$PDoubleFromJson(json);

  Map<String, dynamic> toJson() => _$PDoubleToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoPosition extends PField {
  final GeoPosition defaultValue;

  PGeoPosition({this.defaultValue});

  factory PGeoPosition.fromJson(Map<String, dynamic> json) => _$PGeoPositionFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoPositionToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPostCode extends PField {
  final PostCode defaultValue;

  PPostCode({this.defaultValue});

  factory PPostCode.fromJson(Map<String, dynamic> json) => _$PPostCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PPostCodeToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoLocation extends PField{
  final GeoLocation defaultValue;

  PGeoLocation({this.defaultValue});

  factory PGeoLocation.fromJson(Map<String, dynamic> json) => _$PGeoLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoLocationToJson(this);
}
