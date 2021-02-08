import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/geoPosition.dart';
import 'package:precept_script/schema/field.dart';

part 'list.g.dart';

abstract class PListField extends PField{}

@JsonSerializable(nullable: true, explicitToJson: true)
class PListBoolean extends PListField {
  final List<bool> defaultValue;

   PListBoolean({this.defaultValue = const []});

  factory PListBoolean.fromJson(Map<String, dynamic> json) => _$PListBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$PListBooleanToJson(this);

  Type get modelType=> List;
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PListString extends PListField {
  final List<String> defaultValue;

   PListString({this.defaultValue=const []}) ;

  factory PListString.fromJson(Map<String, dynamic> json) =>
      _$PListStringFromJson(json);

  Map<String, dynamic> toJson() => _$PListStringToJson(this);

  @override
  Type get modelType => String;
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGeoRegion extends PListField {

  final List<GeoPosition> defaultValue;

   PGeoRegion({this.defaultValue}) ;

  factory PGeoRegion.fromJson(Map<String, dynamic> json) =>
      _$PGeoRegionFromJson(json);

  Map<String, dynamic> toJson() => _$PGeoRegionToJson(this);

  @override
  Type get modelType => GeoPosition;
}