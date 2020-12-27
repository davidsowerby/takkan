import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/field.dart';
import 'package:precept_script/schema/list.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/select.dart';


class PSchemaElementMapConverter
    implements JsonConverter<Map<String, PSchemaElement>, Map<String, dynamic>> {
  const PSchemaElementMapConverter();

  @override
  Map<String, PSchemaElement> fromJson(Map<String, dynamic> json) {
    Map<String, PSchemaElement> outputMap = Map();
    for (var entry in json.entries) {
      if (entry.key != "-part-") {
        outputMap[entry.key] = PSchemaElementConverter().fromJson(entry.value);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, PSchemaElement> partMap) {
    final outputMap = Map<String, dynamic>();
    if (partMap == null) {
      return outputMap;
    }
    for (var entry in partMap.entries) {
      outputMap[entry.key] = PSchemaElementConverter().toJson(entry.value);
    }
    return outputMap;
  }
}

class PSchemaElementConverter implements JsonConverter<PSchemaElement, Map<String, dynamic>> {
  const PSchemaElementConverter();

  @override
  PSchemaElement fromJson(Map<String, dynamic> json) {
    final elementType = json["-element-"];
    switch (elementType) {
      case 'PDocument':
        return PDocument.fromJson(json);
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
      case 'PGeoRegion':
        return PGeoRegion.fromJson(json);
      case 'PGeoRegion':
        return PGeoLocation.fromJson(json);
        case 'PPointer':
        return PPointer.fromJson(json);
        case 'PPostCode':
        return PPostCode.fromJson(json);

      case 'PListBoolean':
        return PListBoolean.fromJson(json);
      case 'PListString':
        return PListString.fromJson(json);

      case 'PSelectBoolean':
        return PSelectBoolean.fromJson(json);
      case 'PSelectString':
        return PSelectString.fromJson(json);

      default:
        final msg = "SchemaElement type $elementType not recognised";
        logType(this.runtimeType).e(msg);
        throw SchemaException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(PSchemaElement object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap["-element-"] = type.toString();
    return jsonMap;
  }
}
