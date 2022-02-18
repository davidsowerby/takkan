import 'package:flutter/material.dart';
import 'package:precept_client/common/action/action_icon.dart';
import 'package:precept_client/page/edit_state.dart';
import 'package:provider/provider.dart';

class EditAction extends ActionIcon {
  const EditAction({
    Key? key,
    IconData icon = Icons.edit,
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
    final editState = Provider.of<EditState>(context, listen: false);
    editState.readMode = false;
  }
}

class CancelEditAction extends ActionIcon {
  const CancelEditAction({
    Key? key,
    IconData icon = Icons.cancel_outlined,
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
    final editState = Provider.of<EditState>(context, listen: false);
    editState.readMode = true;
  }
}

class SaveAction extends ActionIcon {
  const SaveAction({
    Key? key,
    IconData icon = Icons.save,
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
    final editState = Provider.of<EditState>(context, listen: false);
    editState.readMode = true;
  }
}
