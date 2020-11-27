import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/document/document.dart';
import 'package:precept_client/precept/document/documentState.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/section/base/section.dart';
import 'package:precept_client/section/base/sectionState.dart';
import 'package:provider/provider.dart';

/// Starts the process of assembling the content of a page based on its [config].
/// This step provides a [DocumentState] and a [Document].
/// The [Document] then uses a Stream to build when the data becomes available
Widget assemblePage({@required PPage config}) {
  final documentState=DocumentState(config: config.document);
  return ChangeNotifierProvider<DocumentState>(
      create: (_) => documentState,
      child: Document(config: config, rootBinding: documentState.rootBinding,));
}

/// Assembles the first level of [Section]s within a [Document], as declared by from [sections].
/// A [SectionState] instance is placed above each [Section] in the Widget Tree, which is used to control the edit state of the [Section] itself, and its contents (which are either [Part]s or sub-[Sections].
/// [rootBinding] is the data binding from a [DocumentState]
Widget assembleSections({@required PPage pPage, RootBinding rootBinding}) {
  final list = List<Widget>();
  for (var pSection in pPage.document.sections) {
    list.add(constructSection(pSection: pSection, baseBinding: rootBinding, isStatic: pPage.isStatic));
  }
  return (pPage.scrollable) ? ListView(children: list) : Column(children: list);
}

/// If [pSection] does not specify a property, [baseBinding] is passed through to the [Section]
/// If [pSection] does specify a property, that property is used to create a new 'child' [ModelBinding] for the section
@visibleForTesting
Widget constructSection({@required PSection pSection, @required ModelBinding baseBinding, bool isStatic}) {
  return ChangeNotifierProvider<SectionState>(
      create: (_) => SectionState(readOnlyMode: isStatic, canEdit: !isStatic),
      child: Section(isStatic:isStatic,
        config: pSection,
        baseBinding: (pSection.property == null)
            ? baseBinding
            : baseBinding.modelBinding(property: pSection.property),
      ));
}


