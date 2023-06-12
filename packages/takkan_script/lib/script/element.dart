import 'package:takkan_schema/common/constants.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';

import '../panel/panel.dart';
import '../panel/static_panel.dart';
import '../part/list_view.dart';
import '../part/navigation.dart';
import '../part/part.dart';
import '../part/query_view.dart';
import '../part/text.dart';
import '../signin/sign_in.dart';
import 'content.dart';

// ignore: avoid_classes_with_only_static_members
class ContentConverter {
  static List<Content> fromJson(List<dynamic> input) {
    final List<Map<String, dynamic>> json = List.castFrom(input);
    final List<Content> list = List.empty(growable: true);
    for (final entry in json) {
      final elementType = entry[jsonClassKey];
      final entryCopy = Map<String, dynamic>.from(entry);
      entryCopy.remove(jsonClassKey);
      switch (elementType) {
        case 'Panel':
          list.add(Panel.fromJson(entryCopy));
          break;
        case 'PanelStatic':
          list.add(PanelStatic.fromJson(entryCopy));
          break;
        case 'Group':
          list.add(Group.fromJson(entryCopy));
          break;
        case 'Part':
          list.add(Part.fromJson(entryCopy));
          break;
        case 'Text':
          list.add(Text.fromJson(entryCopy));
          break;
        case 'NavButton':
          list.add(NavButton.fromJson(entryCopy));
          break;
        case 'NavButtonSet':
          list.add(NavButtonSet.fromJson(entryCopy));
          break;
        case 'EmailSignIn':
          list.add(EmailSignIn.fromJson(entryCopy));
          break;
        case 'QueryView':
          list.add(QueryView.fromJson(entryCopy));
          break;
        case 'ListView':
          list.add(ListView.fromJson(entryCopy));
          break;
        case 'Heading1':
          list.add(Heading1.fromJson(entryCopy));
          break;
        case 'Heading2':
          list.add(Heading2.fromJson(entryCopy));
          break;
        case 'Heading3':
          list.add(Heading3.fromJson(entryCopy));
          break;
        case 'Heading4':
          list.add(Heading4.fromJson(entryCopy));
          break;
        case 'Heading5':
          list.add(Heading5.fromJson(entryCopy));
          break;
        case 'BodyText1':
          list.add(BodyText1.fromJson(entryCopy));
          break;
        case 'BodyText2':
          list.add(BodyText2.fromJson(entryCopy));
          break;
        case 'Title':
          list.add(Title.fromJson(entryCopy));
          break;
        case 'Subtitle':
          list.add(Subtitle.fromJson(entryCopy));
          break;
        case 'Subtitle2':
          list.add(Subtitle2.fromJson(entryCopy));
          break;

        default:
          final msg =
              'JSON conversion has not been implemented for $elementType';
          logType(Object().runtimeType).e(msg);
          throw TakkanException(msg);
      }
    }
    return list;
  }

  static List<Map<String, dynamic>> toJson(List<Content>? elementList) {
    final outputList = List<Map<String, dynamic>>.empty(growable: true);
    if (elementList == null) {
      return outputList;
    }
    for (final entry in elementList) {
      final Map<String, dynamic> outputMap = {};
      outputMap[jsonClassKey] = entry.runtimeType.toString();
      outputMap.addAll(entry.toJson());
      outputList.add(outputMap);
    }
    return outputList;
  }
}
