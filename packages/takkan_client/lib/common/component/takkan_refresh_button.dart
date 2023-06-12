import 'package:flutter/material.dart';

import '../../app/takkan.dart';
import '../action/action_icon.dart';

class TakkanRefreshButton extends ActionIcon {
  @override
  void doAction(BuildContext context) {
    takkan.reload();
  }

  const TakkanRefreshButton({
  Key? key,
  IconData icon = Icons.update,
  List<Function(BuildContext)> onBefore = const [],
  List<Function(BuildContext)> onAfter = const [],
}) : super(key: key, icon: icon, onAfter: onAfter, onBefore: onBefore);
}