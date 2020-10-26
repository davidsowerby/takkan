import 'package:flutter/widgets.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:precept/precept/router.dart';
import 'package:precept/precept/section/contact/address.dart';
import 'package:precept/section/base/section.dart';

class PreceptPageAssembler {
  Widget assemblePage({@required PreceptRoute route}) {
    return ListView(children: assembleSections(route: route));
  }

  Section assembleSection(PreceptSectionLookup sectionLookup) {
    final preceptSection = router.section(sectionLookup);
    return Section(child: AddressWidget());
  }

  /// Visible for testing
  List<Section> assembleSections({@required PreceptRoute route}) {
    final List<Section> children = List();
    for (PreceptSectionLookup sectionLookup in route.page.sections) {
      children.add(assembleSection(sectionLookup));
    }
    return children;
  }
}
