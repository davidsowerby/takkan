import 'package:flutter/widgets.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:precept/precept/router.dart';

class PreceptPageAssembler {
  Widget assemblePage({@required PreceptRoute route}) {
    for (PreceptSectionLookup sectionLookup in route.sections) {
      assembleSection(sectionLookup);
    }
  }

  Widget assembleSection(PreceptSectionLookup sectionLookup) {
    final routeLocatorSet = inject<RouteLocatorSet>();
  }
}
