import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/common/constants.dart';
import 'package:takkan_schema/common/exception.dart';

import 'part.dart';

class PartConverter implements JsonConverter<Part, Map<String, dynamic>> {
  const PartConverter();

  @override
  Part fromJson(Map<String, dynamic> json) {
    final partType = json[jsonClassKey];
    switch (partType) {
      case 'Part':
        return Part.fromJson(json);
      default:
        throw TakkanException('part type $partType not recognised');
    }
  }

  @override
  Map<String, dynamic> toJson(Part object) {
    final type = object.runtimeType;
    final Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[jsonClassKey] = type.toString();
    return jsonMap;
  }
}

class PartMapConverter
    implements JsonConverter<Map<String, Part>, Map<String, dynamic>> {
  const PartMapConverter();

  @override
  Map<String, Part> fromJson(Map<String, dynamic> json) {
    final Map<String, Part> outputMap = {};
    for (final entry in json.entries) {
      if (entry.key != jsonClassKey) {
        outputMap[entry.key] =
            const PartConverter().fromJson(entry.value as Map<String, dynamic>);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, Part> partMap) {
    final outputMap = <String, dynamic>{};
    for (final entry in partMap.entries) {
      outputMap[entry.key] = const PartConverter().toJson(entry.value);
    }
    return outputMap;
  }
}
