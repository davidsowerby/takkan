import 'package:precept/common/exceptions.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/string/stringPart.dart';

/// Common interface for PSection and PPart so both can be held in any order for display
abstract class DisplayElement {
  Map<String, dynamic> toJson();

  String get caption;

  String get property;
}

class PElementListConverter {
  static const elementKeyName = "-element-";

  static List<DisplayElement> fromJson(List<Map<String, dynamic>> json) {
    List<DisplayElement> list = List();
    for (var entry in json) {
      final elementType = entry[elementKeyName];
      final entryCopy = Map<String,dynamic>.from(entry);
      entryCopy.remove(elementKeyName);
      switch (elementType) {
        case "PSection":
          list.add(PSection.fromJson(entryCopy));
          break;
        case "PDocument":
          list.add(PDocument.fromJson(entryCopy));
          break;
        case "PString":
          list.add(PString.fromJson(entryCopy));
          break;
        default:
          throw PreceptException(
              "JSON conversion has not been implemented for $elementType");
      }
    }
    return list;
  }

  static List<Map<String, dynamic>> toJson(List<DisplayElement> elementList) {
    final outputList = List<Map<String, dynamic>>();
    if (elementList == null) {
      return outputList;
    }
    for (var entry in elementList) {
      final Map<String, dynamic> outputMap = Map();
      outputMap[elementKeyName] = entry.runtimeType.toString();
      outputMap.addAll(entry.toJson());
      outputList.add(outputMap);
    }
    return outputList;
  }
}
