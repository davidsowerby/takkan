import 'package:flutter/material.dart';

class NavigationTile extends StatelessWidget {
  final String route;
  final Map<String, dynamic> arguments;
  final Widget? title;
  final Widget? subtitle;

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
      Navigator.of(context).pushNamed(route, arguments: arguments);
  }
}
