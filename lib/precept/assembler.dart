import 'package:flutter/widgets.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:precept/precept/router.dart';

class PreceptPageAssembler {
  Widget assemblePage({@required PreceptRoute route}) {
    PreceptPage page = route.page;
    for (PreceptSectionLookup sectionLookup in page.sections) {
      assembleSection(sectionLookup);
    }
  }

  Widget assembleSection(PreceptSectionLookup sectionLookup) {
    final routeLocatorSet = inject<RouteLocatorSet>();
  }
}
