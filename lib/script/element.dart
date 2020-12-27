import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/logger.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/writingStyle.dart';
import 'package:precept_script/validation/message.dart';

/// Common abstraction for [PPanel] and [PPart] so both can be held in any order for display
class PDisplayElement extends PCommon {
  final String caption;
  final String property;

  PDisplayElement({
    this.caption,
    this.property,
    IsStatic isStatic = IsStatic.inherited,
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    String id,
  }) : super(
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
          id: id,
        );

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (isStatic != IsStatic.yes) {
      if (dataSource == null) {
        messages.add(ValidationMessage(
            item: this, msg: "must either be static or have a dataSource defined"));
      }
    }
    if (dataSource != null) {
      if (backend == null) {
        messages.add(ValidationMessage(
            item: this,
            msg: 'has declared a data source> it must have a backend available as well'));
      }
    }
  }

  @override
  String get idAlternative => caption;
}

class PElementListConverter {
  static const elementKeyName = "-element-";

  static List<PDisplayElement> fromJson(List<Map<String, dynamic>> json) {
    List<PDisplayElement> list = List();
    for (var entry in json) {
      final elementType = entry[elementKeyName];
      final entryCopy = Map<String, dynamic>.from(entry);
      entryCopy.remove(elementKeyName);
      switch (elementType) {
        case "PPanel":
          list.add(PPanel.fromJson(entryCopy));
          break;
        case "PString":
          list.add(PString.fromJson(entryCopy));
          break;

        default:
          final msg = "JSON conversion has not been implemented for $elementType";
          logType(Object().runtimeType).e(msg);
          throw PreceptException(msg);
      }
    }
    return list;
  }

  static List<Map<String, dynamic>> toJson(List<PDisplayElement> elementList) {
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
