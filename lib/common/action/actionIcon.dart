import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Convenience class used to standardise presentation of action icons
class ActionIcon extends StatelessWidget {
  final IconData iconData;
  final Function() action;

  const ActionIcon({Key key, @required this.iconData, @required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 24,
        height: 24,
        child: IconButton(
          icon: Icon(iconData),
          iconSize: 24,
          padding: EdgeInsets.all(0),
          onPressed: action,
        ));
  }
}
