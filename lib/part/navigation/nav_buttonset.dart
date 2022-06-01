import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:takkan_client/part/navigation/nav_button.dart';
import 'package:takkan_client/part/navigation/nav_trait.dart';
import 'package:takkan_script/part/navigation.dart';

class NavButtonSetWidget extends StatelessWidget {
  final NavButtonSet config;
  final NavButtonSetTrait trait;
  final NavButtonTrait buttonTrait;
  final Map<String, dynamic> pageArguments;

  const NavButtonSetWidget(
      {Key? key,
      required this.config,
      required this.buttonTrait,
      required this.trait,
      this.pageArguments = const {}})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = List.empty(growable: true);
    config.buttons.forEach((config) {
      final child = NavButtonPart(
        pageArguments: pageArguments,
        partConfig: config,
        trait: buttonTrait,
        containedInSet: true,
      );
      children.add(child);
    });
    return Row(
      children: [
        Spacer(),
        Container(
          width: config.width ?? trait.width,
          height: trait.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          ),
        ),
        Spacer(),
      ],
    );
  }
}
