import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/common/exceptions.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/document/document.dart';
import 'package:precept/precept/model/element.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/string/stringPart.dart';
import 'package:precept/section/base/section.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

class PreceptPageAssembler {
  const PreceptPageAssembler();

  /// Assembles Widgets from [elements]
  /// [baseBinding] is the data binding for the level of the caller.  [Part]s and [Section]s
  /// attach themselves to that binding.  May be null, when called by a Page (because a document is held at [Document] level,
  /// or where a Widget only contains static text / content and therefore does not require a data binding
  List<Widget> assembleElements(
      {@required List<DisplayElement> elements, MapBinding baseBinding}) {
    final list = List<Widget>();
    for (var element in elements) {
      switch (element.runtimeType) {
        case PString:
          assert(baseBinding !=null);
          list.add(StringPart(
            pPart: element,
            baseBinding: baseBinding,
          ));
          break;
        case PDocument:
          list.add(constructDocument(pDocument: element));
          break;
        case PSection:
          list.add(constructSection(pSection: element, baseBinding: baseBinding));
          break;
        case PStaticText:
          final PStaticText config=element;
          list.add(AutoSizeText(config.text, softWrap: config.softWrap,));
          break;
        default:
          final message = "Assembler not defined for ${element.runtimeType}";
          getLogger(this.runtimeType).e(message);
          throw PreceptException(message);
      }
    }
    return list;
  }

  /// Visible for testing
  Widget constructDocument({@required PDocument pDocument}) {
    return ChangeNotifierProvider<SectionState>(
        create: (_) => SectionState(readOnlyMode: false, canEdit: true),
        child: Document(config: pDocument));
  }

  /// Visible for testing
  /// If [pSection] does not specify a property, [baseBinding] is passed through to the [Section]
  /// If [pSection] does specify a property, that property is used to create a new 'child' [ModelBinding] for the section
  Widget constructSection({@required PSection pSection, @required ModelBinding baseBinding}) {
    return ChangeNotifierProvider<SectionState>(
        create: (_) => SectionState(readOnlyMode: false, canEdit: true),
        child: Section(config: pSection, baseBinding: (pSection.property==null) ? baseBinding :baseBinding.modelBinding(property: pSection.property),));
  }

  /// Visible for testing
// Widget constructSection(
//     {@required PSection section}) {
//   return ChangeNotifierProvider<SectionState>(
//       create: (_) => SectionState(readOnlyMode: false, canEdit: true),
//       child: Section(config: section));
// }

}
