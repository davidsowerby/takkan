import 'package:flutter/widgets.dart';
import 'package:precept/precept/document/documentState.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/section/base/section.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

class PreceptPageAssembler {

  Widget _assembleSection(PSection sectionLookup, DocumentState documentState) {
    return ChangeNotifierProvider<SectionState>(
        create: (_) => SectionState(canEdit: documentState.canEdit,parentSectionBinding: null), child:Section(child: Text("Replace this with a proper part lookup")));
  }

  /// Visible for testing
  List<Section> assembleSections({@required PRoute route, @required DocumentState documentState}) {
    final List<Section> children = List();
    for (PSection sectionLookup in route.page.sections) {
      
      children.add(_assembleSection(sectionLookup,documentState));
    }
    return children;
  }
}

