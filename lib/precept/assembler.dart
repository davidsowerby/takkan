import 'package:flutter/widgets.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/router.dart';
import 'package:precept/section/base/section.dart';

class PreceptPageAssembler {
  Widget assemblePage({@required PRoute route}) {
    return ListView(children: assembleSections(route: route));
  }

  Section assembleSection(PSection sectionLookup) {
    final preceptSection = router.section(sectionLookup);
    return Section(child: Text("Replace this with a proper part lookup"));
  }

  /// Visible for testing
  List<Section> assembleSections({@required PRoute route}) {
    final List<Section> children = List();
    for (PSection sectionLookup in route.page.sections) {
      children.add(assembleSection(sectionLookup));
    }
    return children;
  }
}
