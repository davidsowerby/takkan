import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:precept_client/common/action/action_icon.dart';
import 'package:precept_client/common/component/edit_save_cancel.dart';
import 'package:precept_client/common/component/key_assist.dart';
import 'package:precept_client/common/locale.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/library/border_library.dart';
import 'package:precept_client/library/theme_lookup.dart';
import 'package:precept_client/page/edit_state.dart';
import 'package:precept_client/pod/data_root.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/trait/style.dart';
import 'package:provider/provider.dart';

/// - [openExpanded] if true, the section is set to expand when first created
/// - [actionButtons], if present, are placed before the 'expand' widget
/// - [showEditSave] can be set to false to override the default behaviour of showing the edit/save icons.
/// These icons are supplied by a [EditSaveCancel] widget when [EditState.canEdit] is true.
/// - [dataContext] is only required if the data is to be edited, as it is used in the edit/save/cancel cycle
class Heading extends StatefulWidget {
  final String headingText;
  final PHeadingStyle headingStyle;
  final PHelp? help;
  final Widget Function(bool) expandedContent;
  final bool expandable;
  final bool openExpanded;
  final List<Function(BuildContext)> onBeforeEdit;
  final List<Function(BuildContext)> onAfterEdit;
  final List<Function(BuildContext)> onBeforeCancelEdit;
  final List<Function(BuildContext)> onAfterCancelEdit;
  final List<Function(BuildContext)> onBeforeSave;
  final List<Function(BuildContext)> onAfterSave;
  final bool showEditSave;
  final PPanelHeading config;
  final DataContext? dataContext;
  final DocumentRoot documentRoot;

  const Heading({
    Key? key,
    required this.config,
    this.headingText = 'Heading',
    this.help,
    this.dataContext,
    this.headingStyle = const PHeadingStyle(),
    this.openExpanded = true,
    required this.expandedContent,
    this.expandable = true,
    this.onAfterEdit = const [],
    this.onBeforeEdit = const [],
    this.onBeforeCancelEdit = const [],
    this.onAfterCancelEdit = const [],
    this.onBeforeSave = const [],
    this.onAfterSave = const [],
    this.showEditSave = true,
    required this.documentRoot,
  }) : super(key: key);

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> with Interpolator {
  late bool expanded;
  late ThemeLookup themeLookup;

  @override
  void initState() {
    super.initState();
    expanded = widget.openExpanded;
    themeLookup = inject<ThemeLookup>();
  }

  @override
  Widget build(BuildContext context) {
    final PPanels panelConfig = widget.config.parent as PPanels;
    bool editMode = false;
    bool editable = false;

    if (panelConfig.isStatic) {
      final EditState editState = Provider.of<EditState>(context);
      editable = editState.canEdit;
      editMode = editState.editMode;
    }

    final List<Widget> actionButtons = List.empty(growable: true);

    if (widget.expandable) {
      actionButtons.add(HeadingExpandCloseAction(
          onAfter: [_toggleExpanded], expanded: expanded));
    }

    final theme = Theme.of(context);
    final borderLibrary = inject<BorderLibrary>();
    return Card(
      shape:
          borderLibrary.find(theme: theme, border: widget.headingStyle.border),
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
                        style: widget.headingStyle.textTrait.textStyle,
                      ),
                    ),
                  ),
                  if (widget.help != null)
                    HelpButton(
                      help: widget.help!,
                    ),
                  Spacer(),
                  if (editable)
                    EditSaveCancel(
                      key: keys(widget.key, ['esc']),
                      // documentRoot: widget.documentRoot,
                    ),
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
              child: widget.expandedContent(editMode),
            )
        ],
      ),
    );
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
    Key? key,
    required this.expanded,
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
    Key? key,
    required this.help,
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
