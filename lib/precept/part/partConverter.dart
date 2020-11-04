import 'package:json_annotation/json_annotation.dart';
import 'package:precept/common/exceptions.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/string/stringPart.dart';

// class PPartListConverter
//     implements JsonConverter<List<PPart>, List<Map<String, dynamic>>> {
//   final partConverter = const PPartConverter();
//
//   const PPartListConverter();
//
//   @override
//   List<PPart> fromJson(List<Map<String, dynamic>> json) {
//     List<PPart> list = List();
//     for (var entry in json) {
//       list.add(partConverter.fromJson(entry));
//     }
//     return list;
//   }
//
//   @override
//   List<Map<String, dynamic>> toJson(List<PPart> object) {
//     List<Map<String, dynamic>> list = List();
//     for(var entry in object){
//       list.add(partConverter.toJson(entry));
//     }
//     return list;
//   }
// }

class PPartListConverter{


  static List<PPart> fromJson(List<Map<String, dynamic>> json) {
    List<PPart> list = List();
    for (var entry in json) {
      list.add(PPartConverter().fromJson(entry));
    }
    return list;
  }


  static List<Map<String, dynamic>> toJson(List<PPart> object) {
    List<Map<String, dynamic>> list = List();
    for(var entry in object){
      list.add(PPartConverter().toJson(entry));
    }
    return list;
  }
}



class PPartConverter implements JsonConverter<PPart, Map<String, dynamic>> {
  const PPartConverter();

  @override
  PPart fromJson(Map<String, dynamic> json) {
    final partType = json["-part-"];
    switch (partType) {
      case "PStringPart":
        return PStringPart.fromJson(json);
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
