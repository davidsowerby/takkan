import 'package:flutter/material.dart';
import 'package:takkan_client/common/action/action_icon.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:provider/provider.dart';

class EditAction extends ActionIcon {
  const EditAction({
    super.icon = Icons.edit,
    super.onBefore = const [],
    super.onAfter = const [],
    super.key,
  });

  @override
  void doAction(BuildContext context) {
    final editState = Provider.of<EditState>(context, listen: false);
    editState.readMode = false;
  }
}

class CancelEditAction extends ActionIcon {
  const CancelEditAction({
    super.key,
    super.icon = Icons.cancel_outlined,
    super.onBefore = const [],
    super.onAfter = const [],
  });

  @override
  void doAction(BuildContext context) {
    final editState = Provider.of<EditState>(context, listen: false);
    editState.readMode = true;
  }
}

class SaveAction extends ActionIcon {
  const SaveAction({
    super.key,
    super.icon = Icons.save,
    super.onBefore = const [],
    super.onAfter = const [],
  });

  @override
  void doAction(BuildContext context) {
    final editState = Provider.of<EditState>(context, listen: false);
    editState.readMode = true;
  }
}
