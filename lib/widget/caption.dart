import 'package:flutter/material.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_script/common/script/help.dart';

/// Text styled as a caption
class Caption extends StatelessWidget {
  final String text;
  final PHelp? help;

  const Caption({Key? key, required this.text,required this.help}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caption = Text(
      text,
      style: theme.textTheme.overline,
    );
    return (help == null)
        ? caption
        : Row(
            children: [caption, SizedBox(width: 4,), HelpButton(help: help!)],
          );
  }
}
