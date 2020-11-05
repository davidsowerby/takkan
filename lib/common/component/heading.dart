import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:precept/common/action/actionIcon.dart';
import 'package:precept/common/action/editSave.dart';
import 'package:precept/common/exceptions.dart';
import 'package:precept/common/locale.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

/// - [openExpanded] if true, the section is set to expand when first created
/// - [canEditActions] always has a [EditSaveAction] added when [editable] is true, so there is no need to explicitly add that
/// - [actionButtons], if present, are placed before the 'expand' widget
/// - [showEditIcon] can be set to false to override the default situation of showing the edit icon when [SectionState.canEdit] is true.
/// This is used By [SectionList] for example
class Heading extends StatefulWidget {
  final String headingText;
  final HelpText helpKeys;
  final Widget child;
  final bool editable;
  final bool expandable;
  final DocumentHeadingStyle headingStyle;
  final Function(BuildContext) onEdit;
  final Function(BuildContext) onSave;
  final bool openExpanded;
  final List<Widget> readModeActions;
  final List<Widget> editModeActions;
  final List<Widget> canEditActions;
  final List<Widget> cannotEditActions;
  final bool showEditIcon;

  const Heading({
    Key key,
    this.headingText,
    this.helpKeys,
    this.openExpanded = true,
    @required this.child,
    this.editable = true,
    this.onEdit,
    this.onSave,
    this.headingStyle,
    this.expandable,
    this.readModeActions = const [],
    this.editModeActions = const [],
    this.canEditActions = const [],
    this.cannotEditActions = const [],
    this.showEditIcon = true,
  })  : assert((editable) ? onEdit != null : true,
            "If edit button required, OnEdit must be defined"),
        assert((editable) ? onSave != null : true,
            "If edit required, onSave must also be defined"),
        assert((editable) ? expandable : true,
            "If editable needs also to be expandable"),
        super(key: key);

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> with Interpolator {
  bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.openExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final SectionState sectionState =
        Provider.of<SectionState>(context);
    final List<Widget> actionButtons = (sectionState.readOnlyMode)
        ? List.from(widget.readModeActions)
        : List.from(widget.editModeActions);
    actionButtons.addAll((sectionState.canEdit)
        ? widget.canEditActions
        : widget.cannotEditActions);

    if (sectionState.canEdit && widget.showEditIcon) {
      actionButtons.add(
        EditSaveAction(
          callback: _expand,
        ),
      );
    }

    if (widget.expandable) {
      actionButtons.add(HeadingExpandCloseAction(
          callback: _toggleExpanded, expanded: expanded));
    }

    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.primaryColor, width: 0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 20,
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              height: 40,
              color: widget.headingStyle.headingBackgroundColor,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.headingText,
                      style: widget.headingStyle.textStyle,
                    ),
                  ),
                  if (widget.helpKeys != null)
                    HelpButton(
                      helpText: widget.helpKeys,
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
          if (expanded) widget.child
        ],
      ),
    );
  }

  _expand() {
    if (!expanded) {
      setState(() {
        expanded = true;
      });
    }
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

  const HeadingExpandCloseAction(
      {Key key, @required this.expanded, @required this.callback})
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
  final PSectionHeading config;
  final String headingText;
  final HelpText helpKeys;
  final Widget child;
  final bool canEdit;
  final bool expandable;
  final bool openExpanded;
  final DocumentHeadingStyle headingStyle;
  final List<Widget> readModeActions;
  final List<Widget> editModeActions;
  final List<Widget> canEditActions;
  final List<Widget> cannotEditActions;
  final bool showEditIcon;

  const SectionHeading({
    Key key,
    this.config,
    this.headingText,
    this.showEditIcon = true,
    this.readModeActions = const [],
    this.editModeActions = const [],
    this.canEditActions = const [],
    this.cannotEditActions = const [],
    this.helpKeys,
    this.child,
    this.canEdit,
    this.expandable,
    this.openExpanded = true,
    this.headingStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Heading(
      showEditIcon: showEditIcon,
      helpKeys: helpKeys,
      readModeActions: readModeActions,
      editModeActions: editModeActions,
      canEditActions: canEditActions,
      cannotEditActions: cannotEditActions,
      openExpanded: openExpanded,
      child: child,
      editable: canEdit,
      expandable: expandable,
      headingStyle: headingStyle,
      headingText: headingText,
      onSave: save,
      onEdit: edit,
    );
  }

  edit(BuildContext context) {
    final SectionState sectionState =
        Provider.of<SectionState>(context, listen: false);
    sectionState.readOnlyMode = false;
  }

  save(BuildContext context) {
    final SectionState sectionState =
        Provider.of<SectionState>(context, listen: false);
    sectionState.readOnlyMode = true;
  }
}

class HelpText {
  final String title;
  final String message;

  const HelpText({@required this.title, this.message});
}

class HelpButton extends StatelessWidget with Interpolator {
  final HelpText helpText;

  const HelpButton({Key key, @required this.helpText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionIcon(
        iconData: Icons.help,
        action: () => showOkAlertDialog(
              context: context,
              title: helpText.title,
              message: helpText.message,
            ) // TODO interpolate with params, but params from where.  A Binding with property names maybe?
        );
  }
}

class DocumentHeadingStyle {
  final TextStyle textStyle;
  final double indentation;
  final Color headingBackgroundColor;
  final Border border;
  final int elevation;
  final bool expanding;
  final bool editable;
  final double width;
  final double contentElevation;

  const DocumentHeadingStyle({
    this.textStyle,
    this.indentation = 0,
    this.headingBackgroundColor = Colors.white,
    this.border,
    this.elevation = 20,
    this.expanding = true,
    this.editable = true,
    this.width,
    this.contentElevation = 10,
  });
}

TextStyle lookupTextStyle(
    {Color backgroundColour,
    int sizeIndex,
    bool bold = false,
    bool italic = false,
    Color fontColour = Colors.black}) {
  final FontWeight fontWeight = (bold) ? FontWeight.bold : FontWeight.normal;
  final FontStyle fontStyle = (italic) ? FontStyle.italic : FontStyle.normal;

  switch (sizeIndex) {
    case 0:
      return TextStyle(
        color: fontColour,
        fontSize: 12,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // caption
    case 1:
      return TextStyle(
        color: fontColour,
        fontSize: 14,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // body1
    case 2:
      return TextStyle(
        color: fontColour,
        fontSize: 16,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // body2
    case 3:
      return TextStyle(
        color: fontColour,
        fontSize: 18,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // no equivalent
    case 4:
      return TextStyle(
        color: fontColour,
        fontSize: 20,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // title
    case 5:
      return TextStyle(
        color: fontColour,
        fontSize: 24,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // headline
    case 6:
      return TextStyle(
        color: fontColour,
        fontSize: 34,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // display1
    case 7:
      return TextStyle(
        color: fontColour,
        fontSize: 45,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // display2
    case 8:
      return TextStyle(
        color: fontColour,
        fontSize: 56,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // display3
    case 9:
      return TextStyle(
        color: fontColour,
        fontSize: 112,
        fontWeight: fontWeight,
        backgroundColor: backgroundColour,
        fontStyle: fontStyle,
      ); // display4
    default:
      throw ConfigurationException("Text level $sizeIndex is not supported");
  }
}
