import 'package:json_annotation/json_annotation.dart';
import 'package:precept/common/exceptions.dart';
import 'package:precept/precept/schema/schema.dart';

class SElementMapConverter implements JsonConverter<Map<String, SElement>, Map<String, dynamic>> {
  const SElementMapConverter();

  @override
  Map<String, SElement> fromJson(Map<String, dynamic> json) {
    Map<String, SElement> outputMap = Map();
    for (var entry in json.entries) {
      if (entry.key != "-part-") {
        outputMap[entry.key] = SElementConverter().fromJson(entry.value);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, SElement> partMap) {
    final outputMap = Map<String, dynamic>();
    if (partMap == null) {
      return outputMap;
    }
    for (var entry in partMap.entries) {
      outputMap[entry.key] = SElementConverter().toJson(entry.value);
    }
    return outputMap;
  }
}

class SElementConverter implements JsonConverter<SElement, Map<String, dynamic>> {
  const SElementConverter();

  @override
  SElement fromJson(Map<String, dynamic> json) {
    final elementType = json["-element-"];
    switch (elementType) {
      case "SBoolean":
        return SBoolean.fromJson(json);
      case "SInteger":
        return SInteger.fromJson(json);
      case "SString":
        return SString.fromJson(json);
      case "SDate":
        return SDate.fromJson(json);
      default:
        throw PreceptException("SElement type $elementType not recognised");
    }
  }

  @override
  Map<String, dynamic> toJson(SElement object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap["-element-"] = type.toString();
    return jsonMap;
  }
}
