import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/common/action/toggleEdit.dart';
import 'package:precept/common/component/heading.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/document/document.dart';
import 'package:precept/precept/document/documentState.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/section/base/sectionKey.dart';
import 'package:precept/section/base/sectionList.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

/// A section is an arbitrary collection of Widgets displaying part of a [Document].
/// The Widgets may be [Part] implementations or other sections
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
///
class Section extends StatelessWidget with ToggleSectionEditState {
  final PSection config;
  final MapBinding baseBinding;

  const Section({@required this.config, @required this.baseBinding}) : super();

  @override
  Widget build(BuildContext context) {
    final DocumentState formLog = Provider.of<DocumentState>(context);
    final formKey = GlobalKey<FormState>();
    formLog.addForm(formKey);
    return Form(
      key: formKey,
      child: InkWell(
          onTap: () => toggleEditState(context),
          child: Container(padding: EdgeInsets.all(8), child: _doBuild(context))),
    );
  }

  Widget _doBuild(BuildContext context) {
    final assembler = inject<PreceptPageAssembler>();
    List<Widget> children =
        assembler.assembleElements(elements: config.elements, baseBinding: baseBinding);
    final body = (config.scrollable)
        ? ListView(children: children)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
    if (config.heading == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: body,
      );
    } else {
      return ChangeNotifierProvider<SectionState>(
          create: (_) => SectionState(),
          child: SectionHeading(config: config.heading, help: config.help, child: body));
    }
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
