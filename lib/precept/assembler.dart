import 'package:flutter/widgets.dart';
import 'package:precept/app/page/documentSection.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/model/element.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/string/stringPart.dart';
import 'package:precept/section/base/section.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

class PreceptPageAssembler {
  const PreceptPageAssembler();

  /// Assembles Widgets from [elements]
  /// [baseBinding] is the data binding for the level of the caller.  [Part]s and [Section]s
  /// attach themselves to that binding.  May be null, when called by a Page (because a document is held at [DocumentSection] level,
  /// or where a Widget only contains static text / content and therefore does not require a data binding
  List<Widget> assembleElements({@required List<DisplayElement> elements, MapBinding baseBinding}) {
    final list = List<Widget>();
    for (var element in elements) {
      switch (element.runtimeType) {
        case PString:
          list.add(StringPart(
            pPart: element,
            baseBinding: baseBinding,
          ));
          break;
        case PDocument:
          list.add(constructDocumentSection(documentSection:element));
      }
    }
    return list;
  }

  /// Visible for testing
  Widget constructDocumentSection(
      {@required PDocument documentSection}) {
    return ChangeNotifierProvider<SectionState>(
        create: (_) => SectionState(readOnlyMode: false, canEdit: true),
        child: DocumentSection(config: documentSection));
  }

  /// Visible for testing
  // Widget constructSection(
  //     {@required PSection section}) {
  //   return ChangeNotifierProvider<SectionState>(
  //       create: (_) => SectionState(readOnlyMode: false, canEdit: true),
  //       child: Section(config: section));
  // }


}
