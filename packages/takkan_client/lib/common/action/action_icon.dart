import 'package:flutter/material.dart';

abstract class ActionIcon extends StatelessWidget with ActionInvocation {
  final IconData icon;
  final List<Function(BuildContext)> onBefore;
  final List<Function(BuildContext)> onAfter;

  const ActionIcon({
    Key? key,
    required this.icon,
    this.onBefore = const [],
    this.onAfter = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 24,
        height: 24,
        child: IconButton(
          icon: Icon(icon),
          iconSize: 24,
          padding: EdgeInsets.all(0),
          onPressed: () => action(context),
        ));
  }

  action(BuildContext context) {
    invokeCallbacks(context, onBefore);
    doAction(context);
    invokeCallbacks(context, onAfter);
  }

  void doAction(BuildContext context);
}

mixin ActionInvocation {
  invokeCallbacks(BuildContext context, List<Function(BuildContext)> callbacks) {
    for (var callback in callbacks) {
      callback(context);
    }
  }
}
