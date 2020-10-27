import 'package:flutter/widgets.dart';
import 'package:precept/pc/pc.dart';
import 'package:precept/precept/router.dart';
import 'package:precept/precept/section/contact/address.dart';
import 'package:precept/section/base/section.dart';

class PreceptPageAssembler {
  Widget assemblePage({@required PRoute route}) {
    return ListView(children: assembleSections(route: route));
  }

  Section assembleSection(PSection sectionLookup) {
    final preceptSection = router.section(sectionLookup);
    return Section(child: AddressWidget());
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
