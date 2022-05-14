import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/field/boolean.dart';
import 'package:precept_script/schema/field/date.dart';
import 'package:precept_script/schema/field/double.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/geo_position.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/post_code.dart';
import 'package:precept_script/schema/field/relation.dart';
import 'package:precept_script/schema/field/string.dart';

class SchemaFieldMapConverter
    implements JsonConverter<Map<String, Field>, Map<String, dynamic>> {
  const SchemaFieldMapConverter();

  @override
  Map<String, Field> fromJson(Map<String, dynamic> json) {
    Map<String, Field> outputMap = Map();
    for (var entry in json.entries) {
      if (entry.key != "-part-") {
        outputMap[entry.key] = FieldConverter().fromJson(entry.value);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, Field> partMap) {
    final outputMap = Map<String, dynamic>();
    for (var entry in partMap.entries) {
      outputMap[entry.key] = FieldConverter().toJson(entry.value);
    }
    return outputMap;
  }
}

class FieldConverter implements JsonConverter<Field, Map<String, dynamic>> {
  const FieldConverter();

  @override
  Field fromJson(Map<String, dynamic> json) {
    final elementType = json["-element-"];
    switch (elementType) {
      case 'FBoolean':
        return FBoolean.fromJson(json);
      case 'FInteger':
        return FInteger.fromJson(json);
      case 'FString':
        return FString.fromJson(json);
      case 'FDate':
        return FDate.fromJson(json);
      case 'FDouble':
        return FDouble.fromJson(json);
      case 'FGeoPosition':
        return FGeoPosition.fromJson(json);
      // case 'PGeoRegion':
      //   return PGeoRegion.fromJson(json);
      case 'FGeoRegion':
        return FGeoPosition.fromJson(json);
      case 'FPointer':
        return FPointer.fromJson(json);
      case 'FRelation':
        return FRelation.fromJson(json);
      case 'FPostCode':
        return FPostCode.fromJson(json);

      // case 'PListBoolean':
      //   return PListBoolean.fromJson(json);
      // case 'PListString':
      //   return PListString.fromJson(json);

      // case 'PSelectBoolean':
      //   return PSelectBoolean.fromJson(json);
      // case 'PSelectString':
      //   return PSelectString.fromJson(json);

      default:
        final msg = "SchemaElement type $elementType not recognised";
        logType(this.runtimeType).e(msg);
        throw SchemaException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(Field object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap["-element-"] = type.toString();
    return jsonMap;
  }
}
