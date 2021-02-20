import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:precept_client/common/action/actionIcon.dart';
import 'package:precept_client/common/component/editSaveCancel.dart';
import 'package:precept_client/common/component/keyAssist.dart';
import 'package:precept_client/common/locale.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/library/borderLibrary.dart';
import 'package:precept_client/library/themeLookup.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/style.dart';
import 'package:provider/provider.dart';

/// - [openExpanded] if true, the section is set to expand when first created
/// - [actionButtons], if present, are placed before the 'expand' widget
/// - [showEditSave] can be set to false to override the default behaviour of showing the edit/save icons.
/// These icons are supplied by a [EditSaveCancel] widget when [EditState.canEdit] is true.
/// - [dataSource] is only required if the data is to be edited, as it is used in the edit/save/cancel cycle
class Heading extends StatefulWidget {
  final String headingText;
  final PHeadingStyle headingStyle;
  final PHelp help;
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
  final DataSource dataSource;

  const Heading({
    Key key,
    @required this.config,
    this.headingText,
    this.dataSource,
    this.help,
    this.headingStyle = const PHeadingStyle(),
    this.openExpanded = true,
    @required this.expandedContent,
    this.expandable = true,
    this.onAfterEdit = const [],
    this.onBeforeEdit = const [],
    this.onBeforeCancelEdit = const [],
    this.onAfterCancelEdit = const [],
    this.onBeforeSave = const [],
    this.onAfterSave = const [],
    this.showEditSave = true,
  })  : assert(expandedContent != null),
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
    final PPanel panelConfig = widget.config.parent;
    final EditState editState = Provider.of<EditState>(context);
    final editable = (!(panelConfig.isStatic == IsStatic.yes) && editState.canEdit);

    final List<Widget> actionButtons = List();

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
                  if (editable)
                    EditSaveCancel(key: keys(widget.key, ['esc']), dataSource: widget.dataSource),
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
              child: widget.expandedContent(editState.editMode),
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
