import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/panel/panel.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:precept_client/section/base/section.dart';
import 'package:precept_client/section/base/sectionState.dart';
import 'package:provider/provider.dart';

/// Starts the process of assembling the content of a page based on its [config].
/// This step provides a [DataSource] and a [Panel].
/// The [Panel] then uses a Stream to build when the data becomes available, which then calls on Sections to be built
Widget assemblePage({@required PPage config}) {
  final documentState=DataSource(config: config.dataSource);
  return ChangeNotifierProvider<DataSource>(
      create: (_) => documentState,
      child: Panel(pageConfig: config, rootBinding: documentState.rootBinding,));
}

/// Assembles the first level of [Section]s within a [Panel], as declared by from [content].
/// A [SectionState] instance is placed above each [Section] in the Widget Tree, which is used to control the edit state of the [Section] itself, and its contents (which are either [Part]s or sub-[Sections].
/// [rootBinding] is the data binding from a [DataSource]
Widget assembleSections({@required PPage pPage, RootBinding rootBinding}) {
  final list = List<Widget>();
  for (var pSection in pPage.panels) {
    list.add(constructSection(pSection: pSection, baseBinding: rootBinding, isStatic: pPage.isStatic));
  }
  return (pPage.scrollable) ? ListView(children: list) : Column(children: list);
}

/// If [pSection] does not specify a property, [baseBinding] is passed through to the [Section]
/// If [pSection] does specify a property, that property is used to create a new 'child' [ModelBinding] for the section
@visibleForTesting
Widget constructSection({@required PPanel pSection, @required ModelBinding baseBinding, bool isStatic}) {
  return ChangeNotifierProvider<SectionState>(
      create: (_) => SectionState(readOnlyMode: isStatic, canEdit: !isStatic),
      child: Section(isStatic:isStatic,
        config: pSection,
        baseBinding: (pSection.property == null)
            ? baseBinding
            : baseBinding.modelBinding(property: pSection.property),
      ));
}


