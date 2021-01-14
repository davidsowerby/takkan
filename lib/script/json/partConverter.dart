import 'package:json_annotation/json_annotation.dart';
import 'package:precept_common/common/exception.dart';
import 'package:precept_script/script/pPart.dart';

class PPartConverter implements JsonConverter<PPart, Map<String, dynamic>> {
  const PPartConverter();

  @override
  PPart fromJson(Map<String, dynamic> json) {
    final partType = json["-part-"];
    switch (partType) {
      case "PPart":
        return PPart.fromJson(json);
      default:
        throw PreceptException("part type $partType not recognised");
    }
  }

  @override
  Map<String, dynamic> toJson(PPart object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap["-part-"] = type.toString();
    return jsonMap;
  }
}

class PPartMapConverter
    implements JsonConverter<Map<String, PPart>, Map<String, dynamic>> {
  const PPartMapConverter();

  @override
  Map<String, PPart> fromJson(Map<String, dynamic> json) {
    Map<String, PPart> outputMap = Map();
    for (var entry in json.entries) {
      if (entry.key != "-part-") {
        outputMap[entry.key] = PPartConverter().fromJson(entry.value);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, PPart> partMap) {
    final outputMap = Map<String, dynamic>();
    if (partMap == null) {
      return outputMap;
    }
    for (var entry in partMap.entries) {
      outputMap[entry.key] = PPartConverter().toJson(entry.value);
    }
    return outputMap;
  }
}
