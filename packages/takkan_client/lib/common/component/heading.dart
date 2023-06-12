import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:takkan_client/common/action/action_icon.dart';
import 'package:takkan_client/common/component/edit_save_cancel.dart';
import 'package:takkan_client/common/component/key_assist.dart';
import 'package:takkan_client/common/locale.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:provider/provider.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/script/help.dart';

import '../../data/cache_entry.dart';

/// - [openExpanded] if true, the section is set to expand when first created
/// - [actionButtons], if present, are placed before the 'expand' widget
/// - [showEditSave] can be set to false to override the default behaviour of showing the edit/save icons.
/// These icons are supplied by a [EditSaveCancel] widget when [EditState.canEdit] is true.
/// - [dataContext] is only required if the data is to be edited, as it is used in the edit/save/cancel cycle
class Heading extends StatefulWidget {
  final String headingText;
  final Help? help;
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
  final PanelHeading config;
  final DataContext? dataContext;
  final CacheEntry cacheEntry;

  const Heading({
    Key? key,
    required this.config,
    this.headingText = 'Heading',
    this.help,
    this.dataContext,
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
    required this.cacheEntry,
  }) : super(key: key);

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> with Interpolator {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.openExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final Panels panelConfig = widget.config.parent as Panels;
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
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
      elevation: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggleExpanded(context),
            child: Container(
              height: 90,
              color: theme.colorScheme.onBackground,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.headingText,
                      style: theme.textTheme.bodyMedium!,
                    ),
                  ),
                  if (widget.help != null)
                    HelpButton(
                      help: widget.help!,
                    ),
                  Spacer(),
                  if (editable)
                    EditSaveCancel(cacheEntry: widget.cacheEntry,
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
  final Help help;

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
