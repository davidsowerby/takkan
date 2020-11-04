import 'package:flutter/widgets.dart';
import 'package:precept/app/page/documentSection.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/string/stringPart.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

class PreceptPageAssembler {
  const PreceptPageAssembler();

  Widget _assembleSection(PSection section, MapBinding baseBinding) {
    return Column(children: assembleParts(section.parts, baseBinding));
    // return Section(child: Text("Replace this with a proper part lookup"));
  }

  List<Widget> assembleParts(List<PPart> parts, MapBinding baseBinding) {
    final list = List<Widget>();
    for (var part in parts) {
      switch (part.runtimeType) {
        case PStringPart:
          list.add(StringPart(pPart: part, baseBinding: baseBinding,));
          break;
      }
    }
    return list;
  }

  /// Visible for testing
  List<Widget> assembleDocumentSections({@required PRoute route}) {
    final List<Widget> children = List();
    for (PDocumentSection section in route.page.sections) {
      children.add(ChangeNotifierProvider<SectionState>(
          create: (_) => SectionState(readOnlyMode: false, canEdit: true),
          child: DocumentSection(config: section)));
    }
    return children;
  }

  assembleSections({@required PSection section, RootBinding baseBinding}) {
    final List<Widget> children = List();
    for (PSection section in section.sections) {
      children.add(_assembleSection(section, baseBinding));
    }
    return children;
  }
}
