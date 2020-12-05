import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:precept_client/common/action/actionIcon.dart';
import 'package:precept_client/common/action/editSave.dart';
import 'package:precept_client/common/locale.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/library/borderLibrary.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:precept_client/precept/script/style.dart';
import 'package:precept_client/precept/script/themeLookup.dart';
import 'package:precept_client/section/base/sectionState.dart';
import 'package:provider/provider.dart';

/// - [openExpanded] if true, the section is set to expand when first created
/// - [canEditActions] always has a [EditSaveAction] added when [editable] is true, so there is no need to explicitly add that
/// - [actionButtons], if present, are placed before the 'expand' widget
/// - [showEditIcon] can be set to false to override the default situation of showing the edit icon when [SectionState.canEdit] is true.
/// - [persistOnSave] if true, when a save action is executed, the nearest [DataSource] is called to persist the document
/// This is used By [SectionList] for example
class Heading extends StatefulWidget {
  final String headingText;
  final PHeadingStyle headingStyle;
  final PHelp help;
  final Widget child;
  final bool editable;
  final bool expandable;
  final Function(BuildContext) onEdit;
  final Function(BuildContext) onSave;
  final bool openExpanded;
  final List<Widget> readModeActions;
  final List<Widget> editModeActions;
  final List<Widget> canEditActions;
  final List<Widget> cannotEditActions;
  final bool showEditIcon;
  final bool persistOnSave;

  const Heading({
    Key key,
    this.headingText,
    this.help,
    this.headingStyle = const PHeadingStyle(),
    this.openExpanded = true,
    @required this.child,
    this.editable = true,
    this.onEdit,
    this.onSave,
    this.persistOnSave=true,
    this.expandable = true,
    this.readModeActions = const [],
    this.editModeActions = const [],
    this.canEditActions = const [],
    this.cannotEditActions = const [],
    this.showEditIcon = true,
  })  : assert(child != null),
        assert(
            (editable) ? onEdit != null : true, "If edit button required, OnEdit must be defined"),
        assert((editable) ? onSave != null : true, "If edit required, onSave must also be defined"),
        assert((editable) ? expandable : true, "If editable needs also to be expandable"),
        super(key: key);

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> with Interpolator {
  bool expanded;
  ThemeLookup themeLookup;

  @override
  void initState() {
    super.initState();
    expanded = widget.openExpanded;
    themeLookup = inject<ThemeLookup>();
  }

  @override
  Widget build(BuildContext context) {
    final SectionState sectionState = Provider.of<SectionState>(context);
    final List<Widget> actionButtons = (sectionState.readOnlyMode)
        ? List.from(widget.readModeActions)
        : List.from(widget.editModeActions);
    actionButtons.addAll((sectionState.canEdit) ? widget.canEditActions : widget.cannotEditActions);

    /// Pressing edit also expands the heading - otherwise it cannot be edited
    if (sectionState.canEdit && widget.showEditIcon) {
      List<Future<bool> Function(BuildContext,bool)> callbacks = List();
      callbacks.add(_expand);
      if(widget.persistOnSave){
        DataSource documentState= Provider.of<DataSource>(context, listen: false);
        callbacks.add(documentState.persist);
      }
      actionButtons.add(
        EditSaveAction(
          callbacks: callbacks,
        ),
      );
    }

    if (widget.expandable) {
      actionButtons.add(HeadingExpandCloseAction(callback: _toggleExpanded, expanded: expanded));
    }

    final theme = Theme.of(context);
    final borderLibrary = inject<BorderLibrary>();
    return Card(
      shape: borderLibrary.find(theme: theme, border: widget.headingStyle.border),
      elevation: widget.headingStyle.elevation,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              height: widget.headingStyle.height,
              color: themeLookup.color(
                theme: theme,
                pColor: widget.headingStyle.background,
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.headingText,
                      style: themeLookup.textStyle(
                        theme: theme,
                        style: widget.headingStyle.style,
                      ),
                    ),
                  ),
                  if (widget.help != null)
                    HelpButton(
                      help: widget.help,
                    ),
                  Spacer(),
                  if (actionButtons.isNotEmpty)
                    Row(
                      children: actionButtons,
                    ),
                ],
              ),
            ),
          ),
          if (expanded) Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.child,
          )
        ],
      ),
    );
  }

  Future<bool> _expand(BuildContext context, bool readOnly) async{
    if (!expanded) {
      setState(() {
        expanded = true;
      });
    }
    return true;
  }

  _toggleExpanded() {
    setState(() {
      expanded = !expanded;
    });
  }
}

class HeadingExpandCloseAction extends StatelessWidget {
  final bool expanded;
  final Function() callback;

  const HeadingExpandCloseAction({Key key, @required this.expanded, @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionIcon(
      iconData: (expanded) ? Icons.arrow_drop_down : Icons.arrow_drop_up,
      action: _execute,
    );
  }

  _execute() {
    callback();
  }
}

class SectionHeading extends StatelessWidget {
  final PPanelHeading config;
  final PHelp help;
  final Widget child;
  final List<Widget> readModeActions;
  final List<Widget> editModeActions;
  final List<Widget> canEditActions;
  final List<Widget> cannotEditActions;
  final bool showEditIcon;

  const SectionHeading({
    Key key,
    @required this.config,
    this.showEditIcon = true,
    this.readModeActions = const [],
    this.editModeActions = const [],
    this.canEditActions = const [],
    this.cannotEditActions = const [],
    this.help,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sectionState = Provider.of<SectionState>(context);
    return Heading(headingStyle: config.style,
      showEditIcon: showEditIcon,
      help: help,
      readModeActions: readModeActions,
      editModeActions: editModeActions,
      canEditActions: canEditActions,
      cannotEditActions: cannotEditActions,
      openExpanded: config.openExpanded,
      child: child,
      editable: (!config.canEdit) ? false : sectionState.canEdit,
      expandable: config.expandable,
      headingText: config.title,
      onSave: save,
      onEdit: edit,
    );
  }

  edit(BuildContext context) {
    final SectionState sectionState = Provider.of<SectionState>(context, listen: false);
    sectionState.readOnlyMode = false;
  }

  save(BuildContext context) {
    final SectionState sectionState = Provider.of<SectionState>(context, listen: false);
    sectionState.readOnlyMode = true;
  }
}

class HelpButton extends StatelessWidget with Interpolator {
  final PHelp help;

  const HelpButton({Key key, @required this.help}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionIcon(
        iconData: Icons.help,
        action: () => showOkAlertDialog(
              context: context,
              title: help.title,
              message: help.message,
            ) // TODO interpolate with params, but params from where.  A Binding with property names maybe?
        );
  }
}
