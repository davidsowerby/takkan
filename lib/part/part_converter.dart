import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/part/part.dart';

class PartConverter implements JsonConverter<Part, Map<String, dynamic>> {
  const PartConverter();

  @override
  Part fromJson(Map<String, dynamic> json) {
    final partType = json["-part-"];
    switch (partType) {
      case "PPart":
        return Part.fromJson(json);
      default:
        throw PreceptException("part type $partType not recognised");
    }
  }

  @override
  Map<String, dynamic> toJson(Part object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap["-part-"] = type.toString();
    return jsonMap;
  }
}

class PartMapConverter
    implements JsonConverter<Map<String, Part>, Map<String, dynamic>> {
  const PartMapConverter();

  @override
  Map<String, Part> fromJson(Map<String, dynamic> json) {
    Map<String, Part> outputMap = Map();
    for (var entry in json.entries) {
      if (entry.key != "-part-") {
        outputMap[entry.key] = PartConverter().fromJson(entry.value);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, Part> partMap) {
    final outputMap = Map<String, dynamic>();
    for (var entry in partMap.entries) {
      outputMap[entry.key] = PartConverter().toJson(entry.value);
    }
    return outputMap;
  }
}
