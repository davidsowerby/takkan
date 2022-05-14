import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/static_panel.dart';
import 'package:precept_script/part/list_view.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/part/query_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/signin/sign_in.dart';

class ContentConverter {
  static const elementKeyName = "-element-";

  static List<Content> fromJson(List<dynamic> json) {
    List<Content> list = List.empty(growable: true);
    for (var entry in json) {
      final elementType = entry[elementKeyName];
      final entryCopy = Map<String, dynamic>.from(entry);
      entryCopy.remove(elementKeyName);
      switch (elementType) {
        case "Panel":
          list.add(Panel.fromJson(entryCopy));
          break;
        case "PanelStatic":
          list.add(PanelStatic.fromJson(entryCopy));
          break;
        case "Group":
          list.add(Group.fromJson(entryCopy));
          break;
        case "Part":
          list.add(Part.fromJson(entryCopy));
          break;
        case "Text":
          list.add(Text.fromJson(entryCopy));
          break;
        case "NavButton":
          list.add(NavButton.fromJson(entryCopy));
          break;
        case "NavButtonSet":
          list.add(NavButtonSet.fromJson(entryCopy));
          break;
        case "EmailSignIn":
          list.add(EmailSignIn.fromJson(entryCopy));
          break;
        case "QueryView":
          list.add(QueryView.fromJson(entryCopy));
          break;
        case "ListView":
          list.add(ListView.fromJson(entryCopy));
          break;

        default:
          final msg =
              "JSON conversion has not been implemented for $elementType";
          logType(Object().runtimeType).e(msg);
          throw PreceptException(msg);
      }
    }
    return list;
  }

  static List<Map<String, dynamic>> toJson(List<Content>? elementList) {
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
