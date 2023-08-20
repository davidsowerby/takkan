import 'package:flutter/material.dart';
import 'package:takkan_client/common/on_color.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/part/navigation/nav_trait.dart';
import 'package:takkan_client/part/part.dart';
import 'package:takkan_client/part/trait.dart';
import 'package:takkan_script/part/navigation.dart';

import '../../library/trait_library.dart';

class NavButtonPart extends StatelessWidget {
  final NavButton partConfig;
  final NavButtonTrait trait;
  final Map<String, dynamic> pageArguments;
  final bool containedInSet;

  NavButtonPart({
    Key? key,
    this.containedInSet = false,
    required this.partConfig,
    required this.trait,
    this.pageArguments = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
        onPressed: () => navigateTo(context),
        child: Text(
          partConfig.caption!,
        ));
    return (containedInSet)
        ? button
        : Container(alignment: trait.readTrait.alignment, child: button);
  }

  navigateTo(BuildContext context) {
    Navigator.pushNamed(context, partConfig.route, arguments: pageArguments);
  }
}

class NavButtonPartBuilder implements PartBuilder<NavButton, NavButtonPart> {
  @override
  NavButtonPart createPart({
    required NavButton config,
    required ThemeData theme,
    required DataContext dataContext,
    required DataBinding parentDataBinding,
    OnColor onColor = OnColor.surface,
  }) {
    final Trait trait = traitLibrary.find(config: config, theme: theme);
    return NavButtonPart(
      partConfig: config,
      trait: trait as NavButtonTrait,
    );
  }
}
