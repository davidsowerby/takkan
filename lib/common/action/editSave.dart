import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/common/action/actionIcon.dart';
import 'package:precept/common/action/toggleEdit.dart';
import 'package:precept/common/editState/sectionEditState.dart';
import 'package:provider/provider.dart';

/// Toggles the read only state of the nearest [SectionEditState]
class EditSaveAction extends StatelessWidget with ToggleSectionEditState {
  final Function() callback;

  const EditSaveAction({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SectionEditState sectionEditState =
        Provider.of<SectionEditState>(context);
    final icon = (sectionEditState.readMode) ? Icons.edit : Icons.check;
    return ActionIcon(
      iconData: icon,
      action: () => _execute(context),
    );
  }

  _execute(BuildContext context) {
    toggleEditState(context);
    if (callback != null) callback();
  }
}
