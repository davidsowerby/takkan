import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/part/query_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/signin/sign_in.dart';

class PElementListConverter {
  static const elementKeyName = "-element-";

  static List<PSubContent> fromJson(List<dynamic> json) {
    List<PSubContent> list = List.empty(growable: true);
    for (var entry in json) {
      final elementType = entry[elementKeyName];
      final entryCopy = Map<String, dynamic>.from(entry);
      entryCopy.remove(elementKeyName);
      switch (elementType) {
        case "PPanel":
          list.add(PPanel.fromJson(entryCopy));
          break;
        case "PPart":
          list.add(PPart.fromJson(entryCopy));
          break;
        case "PText":
          list.add(PText.fromJson(entryCopy));
          break;
        case "PNavButton":
          list.add(PNavButton.fromJson(entryCopy));
          break;
        case "PNavButtonSet":
          list.add(PNavButtonSet.fromJson(entryCopy));
          break;
        case "PEmailSignIn":
          list.add(PEmailSignIn.fromJson(entryCopy));
          break;
        case "PQueryView":
          list.add(PQueryView.fromJson(entryCopy));
          break;

        default:
          final msg = "JSON conversion has not been implemented for $elementType";
          logType(Object().runtimeType).e(msg);
          throw PreceptException(msg);
      }
    }
    return list;
  }

  static List<Map<String, dynamic>> toJson(List<PSubContent>? elementList) {
    final outputList = List<Map<String, dynamic>>.empty(growable: true);
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
