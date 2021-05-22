import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationTile extends StatelessWidget {
  final String route;
  final Map<String, dynamic> arguments;
  final Text? title;
  final Text? subtitle;

  const NavigationTile({
    Key? key,
    required this.route,
    this.arguments = const {},
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      onTap: () => navigate(context),
    );
  }

  navigate(BuildContext context) {
    if (route != null) {
      Navigator.of(context).pushNamed(route, arguments: arguments);
    }
  }
}
