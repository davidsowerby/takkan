import 'package:flutter/material.dart';
import 'package:takkan_client/common/component/heading.dart';
import 'package:takkan_script/script/help.dart';

/// Text styled as a caption
class Caption extends StatelessWidget {
  final String text;
  final Help? help;

  const Caption({super.key, required this.text, required this.help});

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
            children: [
              caption,
              SizedBox(
                width: 4,
              ),
              HelpButton(help: help!)
            ],
          );
  }
}
