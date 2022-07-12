import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../common/exception.dart';
import '../../common/log.dart';
import '../field/boolean.dart';
import '../field/date.dart';
import '../field/double.dart';
import '../field/field.dart';
import '../field/geo_position.dart';
import '../field/integer.dart';
import '../field/pointer.dart';
import '../field/post_code.dart';
import '../field/relation.dart';
import '../field/string.dart';

class SchemaFieldMapConverter
    implements JsonConverter<Map<String, Field<dynamic>>, Map<String, dynamic>> {
  const SchemaFieldMapConverter();

  @override
  Map<String, Field<dynamic>> fromJson(Map<String, dynamic> json) {
    final Map<String, Field<dynamic>> outputMap = {};
    for (final entry in json.entries) {
      if (entry.key != jsonClassKey) {
        outputMap[entry.key] = const FieldConverter().fromJson(entry.value as Map<String,dynamic>);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, Field<dynamic>> partMap) {
    final outputMap = <String, dynamic>{};
    for (final entry in partMap.entries) {
      outputMap[entry.key] = const FieldConverter().toJson(entry.value);
    }
    return outputMap;
  }
}

class FieldConverter implements JsonConverter<Field<dynamic>, Map<String, dynamic>> {
  const FieldConverter();

  @override
  Field<dynamic> fromJson(Map<String, dynamic> json) {
    final elementType = json[jsonClassKey];
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
        final msg = 'SchemaElement type $elementType not recognised';
        logType(runtimeType).e(msg);
        throw SchemaException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(Field<dynamic> object) {
    final type = object.runtimeType;
    final Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[jsonClassKey] = type.toString();
    return jsonMap;
  }
}
