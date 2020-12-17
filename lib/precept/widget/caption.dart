import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Text styled as a caption
class Caption extends StatelessWidget {
  final String text;

  const Caption({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.overline,
    );
  }
}
