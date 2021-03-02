import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/writingStyle.dart';
import 'package:precept_script/validation/message.dart';

/// Common abstraction for [PPanel] and [PPart] so both can be held in any order for display
/// Separated from [PContent], because it does not really make sense to contain a page within a page
///
/// However, it does not really make sense for a [PPart] to define a [dataProvider] or [query],
/// so these are not declared by a [PPart], and therefore effectively unused by a [PPart]
class PSubContent extends PContent {
  PSubContent({
    String caption,
    String property,
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.inherited,
    String id,
  }) : super(
          caption: caption,
          property: property,
          isStatic: isStatic,
          dataProvider: dataProvider,
          query: query,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
          id: id,
        );

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (isStatic != IsStatic.yes) {
      if (property == null) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: 'is not static, and must therefore declare a property (which can be an empty String)',
          ),
        );
      }
      if (!hasEditControl && !(inheritedEditControl)) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: 'is not static, but there is no editControl set in this or its parent chain',
          ),
        );
      }
      if (query == null) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: "must either be static or have a query defined",
          ),
        );
      }

    }
    if (query != null) {
      if (dataProvider == null) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: 'has declared a data source, but it must have a dataProvider available as well',
          ),
        );
      }
    }

  }

  @override
  String get idAlternative => caption;
}

class PElementListConverter {
  static const elementKeyName = "-element-";

  static List<PSubContent> fromJson(List<Map<String, dynamic>> json) {
    List<PSubContent> list = List();
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

        default:
          final msg = "JSON conversion has not been implemented for $elementType";
          logType(Object().runtimeType).e(msg);
          throw PreceptException(msg);
      }
    }
    return list;
  }

  static List<Map<String, dynamic>> toJson(List<PSubContent> elementList) {
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
