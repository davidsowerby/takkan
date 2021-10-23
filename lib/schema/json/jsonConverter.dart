import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/field/boolean.dart';
import 'package:precept_script/schema/field/date.dart';
import 'package:precept_script/schema/field/double.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/geoPosition.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/postCode.dart';
import 'package:precept_script/schema/field/relation.dart';
import 'package:precept_script/schema/field/string.dart';

class PSchemaFieldMapConverter
    implements JsonConverter<Map<String, PField>, Map<String, dynamic>> {
  const PSchemaFieldMapConverter();

  @override
  Map<String, PField> fromJson(Map<String, dynamic> json) {
    Map<String, PField> outputMap = Map();
    for (var entry in json.entries) {
      if (entry.key != "-part-") {
        outputMap[entry.key] = PFieldConverter().fromJson(entry.value);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, PField> partMap) {
    final outputMap = Map<String, dynamic>();
    for (var entry in partMap.entries) {
      outputMap[entry.key] = PFieldConverter().toJson(entry.value);
    }
    return outputMap;
  }
}

class PFieldConverter implements JsonConverter<PField, Map<String, dynamic>> {
  const PFieldConverter();

  @override
  PField fromJson(Map<String, dynamic> json) {
    final elementType = json["-element-"];
    switch (elementType) {
      case 'PBoolean':
        return PBoolean.fromJson(json);
      case 'PInteger':
        return PInteger.fromJson(json);
      case 'PString':
        return PString.fromJson(json);
      case 'PDate':
        return PDate.fromJson(json);
      case 'PDouble':
        return PDouble.fromJson(json);
      case 'PGeoPosition':
        return PGeoPosition.fromJson(json);
      // case 'PGeoRegion':
      //   return PGeoRegion.fromJson(json);
      case 'PGeoRegion':
        return PGeoPosition.fromJson(json);
      case 'PPointer':
        return PPointer.fromJson(json);
      case 'PRelation':
        return PRelation.fromJson(json);
      case 'PPostCode':
        return PPostCode.fromJson(json);

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
  Map<String, dynamic> toJson(PField object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap["-element-"] = type.toString();
    return jsonMap;
  }
}
