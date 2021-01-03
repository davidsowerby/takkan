import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:precept_client/common/action/actionIcon.dart';
import 'package:precept_client/common/action/editSave.dart';
import 'package:precept_client/common/locale.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/library/borderLibrary.dart';
import 'package:precept_client/library/themeLookup.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/style/style.dart';
import 'package:provider/provider.dart';

/// - [openExpanded] if true, the section is set to expand when first created
/// - actions are supported for Edit, Save and Cancel, but an [EditSaveCancel] instance should be added if required
/// - [actionButtons], if present, are placed before the 'expand' widget
/// - [showEditIcon] can be set to false to override the default situation of showing the edit icon when [EditState.canEdit] is true.
class Heading extends StatefulWidget {
  final String headingText;
  final PHeadingStyle headingStyle;
  final PHelp help;
  final Widget Function() expandedContent;
  final bool editable;
  final bool expandable;
  final bool openExpanded;
  final List<Function(BuildContext)> onBeforeEdit;
  final List<Function(BuildContext)> onAfterEdit;
  final List<Function(BuildContext)> onBeforeCancelEdit;
  final List<Function(BuildContext)> onAfterCancelEdit;
  final List<Function(BuildContext)> onBeforeSave;
  final List<Function(BuildContext)> onAfterSave;
  final bool showEditIcon;

  const Heading({
    Key key,
    this.headingText,
    this.help,
    this.headingStyle = const PHeadingStyle(),
    this.openExpanded = true,
    @required this.expandedContent,
    this.editable = true,
    this.expandable = true,
    this.onAfterEdit = const [],
    this.onBeforeEdit = const [],
    this.onBeforeCancelEdit = const [],
    this.onAfterCancelEdit = const [],
    this.onBeforeSave = const [],
    this.onAfterSave = const [],
    this.showEditIcon = true,
  })  : assert(expandedContent != null),
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
    final EditState editState = Provider.of<EditState>(context);

    final List<Widget> actionButtons = List();

    if (editState.readMode) {
      actionButtons.add(
        EditAction(
          onBefore: widget.onBeforeEdit,
          onAfter: widget.onAfterEdit,
        ),
      );
    }

    if (editState.editMode) {
      actionButtons.add(CancelEditAction(
        onBefore: widget.onBeforeCancelEdit,
        onAfter: widget.onAfterCancelEdit,
      ));

      actionButtons.add(SaveAction(
        onBefore: widget.onBeforeSave,
        onAfter: widget.onAfterSave,
      ));
    }

    if (widget.expandable) {
      actionButtons.add(HeadingExpandCloseAction(onAfter: [_toggleExpanded], expanded: expanded));
    }

    final theme = Theme.of(context);
    final borderLibrary = inject<BorderLibrary>();
    return Card(
      shape: borderLibrary.find(theme: theme, border: widget.headingStyle.border),
      elevation: widget.headingStyle.elevation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggleExpanded(context),
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
          if (expanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.expandedContent(),
            )
        ],
      ),
    );
  }

  Future<bool> _expand(BuildContext context, bool readOnly) async {
    if (!expanded) {
      setState(() {
        expanded = true;
      });
    }
    return true;
  }

  /// [context] is not used, but needs it for the callback signature
  _toggleExpanded(BuildContext context) {
    setState(() {
      expanded = !expanded;
    });
  }
}

class HeadingExpandCloseAction extends ActionIcon {
  final bool expanded;

  const HeadingExpandCloseAction({
    Key key,
    this.expanded,
    List<Function(BuildContext)> onBefore = const [],
    List<Function(BuildContext)> onAfter = const [],
  }) : super(
          key: key,
          icon: (expanded) ? Icons.arrow_drop_down : Icons.arrow_drop_up,
          onAfter: onAfter,
          onBefore: onBefore,
        );

  @override
  void doAction(BuildContext context) {
    /// Only action is in the callback
  }
}

class HelpButton extends ActionIcon with Interpolator {
  final PHelp help;

  const HelpButton({
    Key key,
    @required this.help,
    IconData icon = Icons.help,
    List<Function(BuildContext)> onBefore = const [],
    List<Function(BuildContext)> onAfter = const [],
  }) : super(
          key: key,
          icon: icon,
          onAfter: onAfter,
          onBefore: onBefore,
        );

  @override
  void doAction(BuildContext context) {
    showOkAlertDialog(
      context: context,
      title: help.title,
      message: help.message,
    ); // TODO interpolate with params, but params from where.  A Binding with property names maybe?
  }
}
