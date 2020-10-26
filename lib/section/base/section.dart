import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/common/action/toggleEdit.dart';
import 'package:precept/common/component/heading.dart';
import 'package:precept/section/base/documentModelShared.dart';
import 'package:precept/section/base/sectionBinding.dart';
import 'package:precept/section/base/sectionKey.dart';
import 'package:precept/section/base/sectionList.dart';
import 'package:provider/provider.dart';

/// A section is an arbitrary collection of widgets displaying part of a [DocumentModel].
///
/// It is intended that sections are defined only once, and re-used in documents, forms and wizards.
///
/// A section uses [Part] instances to display data in either read-only or edit mode as determined by the [SectionEditState] positioned
/// above the section in the Widget tree.
///
/// There are a number of section [AbstractSection] implementations.  Each is a 'wrapper', used to determine the layout of its enclosed section widget.
///
/// - [Section] the most commonly used, the standard style of presentation within a document
/// - [PopoutSection], typically used in a [SectionList], where each section is represented by a [NavigationTile],
/// which is then tapped to navigate to a page displaying the section in its own page
/// - [WizardSection] displays the section as a wizard step, and also adds some control properties to support the wizard "process".
/// - [SectionGroup] is an arbitrary group of sections, but is also treated as a section in its own right
/// - [SectionList] is a list of section instances of the same same section type, but is also treated as a section in its own right
///
/// This class is used as an interface, primarily for type safety.
///
/// For collections of sections is see [SectionGroup] and [SectionList]
///
/// [child] is the widget that presents the section's data - for example [AddressSection]

class Section extends StatelessWidget
    with ToggleSectionEditState, DocumentSection {
  final Widget child;

  final dynamic subTitleKey;
  final String titleProperty;
  final String subTitleProperty;
  final String Function() title;
  final String Function() subTitle;
  final String route;
  final HelpText helpKeys;
  final dynamic lookupKey;
  final dynamic titleKey;
  final String bindingProperty;

  Section({
    Key key,
    @required this.child,
    this.subTitleKey,
    this.titleProperty,
    this.subTitleProperty,
    this.title,
    this.subTitle,
    this.route,
    this.lookupKey,
    this.helpKeys,
    this.titleKey,
    this.bindingProperty,
  }) :

//        assert(child != null),
//        assert(child is SectionList ? (bindingProperty != null) : true, "List binding always needs binding property"),
        super(
          key: key,
        );

  SectionKey get keyId => SectionKey(lookupKey: lookupKey, titleKey: titleKey);

  @override
  Widget build(BuildContext context) {
    final SectionBinding sectionBinding = Provider.of<SectionBinding>(context);
    final DocumentModelShared documentEditState =
        Provider.of<DocumentModelShared>(context);
    if (child is SectionList) {
      return ChangeNotifierProvider<SectionBinding>(
          create: (_) => SectionBinding(
                parentSectionBinding: sectionBinding,
                dataBinding: sectionBinding.dataBinding
                    .listBinding(property: bindingProperty),
              ),
          child: child);
    }
    final formKey = GlobalKey<FormState>();
    documentEditState.addForm(formKey);
    return Form(
      key: formKey,
      child: ChangeNotifierProvider(
          create: (_) => SectionBinding(
                parentSectionBinding: sectionBinding,
                dataBinding:
                    (bindingProperty == null || bindingProperty.isEmpty)
                        ? sectionBinding.dataBinding
                        : sectionBinding.dataBinding
                            .modelBinding(property: bindingProperty),
              ),
          child: InkWell(
              onTap: () => toggleEditState(context),
              child: Container(padding: EdgeInsets.all(8), child: child))),
    );
  }
}

class WizardSection extends StatelessWidget {
  final Widget child;

  const WizardSection({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

///// An implementation of [AbstractSection] for sections positioned within a document.  See also [CollectionSection] and
///// [WizardSection]
//class CollectionSection extends AbstractSection {
//  final String bindingProperty;
//  final dynamic titleKey;
//  final dynamic subTitleKey;
//  final String titleProperty;
//  final String subTitleProperty;
//  final String Function() title;
//  final String Function() subTitle;
//  final String route;
//
//  const CollectionSection({
//    Key key,
//    this.bindingProperty,
//    @required Widget child,
//    this.titleKey,
//    this.subTitleKey,
//    this.titleProperty,
//    this.subTitleProperty,
//    this.title,
//    this.subTitle,
//    this.route,
//  })  : assert(child != null),
//        assert(child is SectionList ? (bindingProperty != null) : true, "List binding always needs binding property"),
//        super(key: key, child: child);
//
//  @override
//  Widget build(BuildContext context) {
//    final SectionBinding sectionBinding = Provider.of<SectionBinding>(context);
//    if (child is SectionList) {
//      return ChangeNotifierProvider<SectionBinding>(
//          create: (_) => SectionBinding(
//                listBinding: sectionBinding.mapBinding.listBinding(property: bindingProperty),
//              ),
//          child: child);
//    }
//    return ChangeNotifierProvider(
//        create: (_) => SectionBinding(
//              mapBinding: (bindingProperty == null || bindingProperty.isEmpty)
//                  ? sectionBinding.mapBinding
//                  : sectionBinding.mapBinding.mapBinding(property: bindingProperty),
//            ),
//        child: Container(child: child));
//  }
//}
