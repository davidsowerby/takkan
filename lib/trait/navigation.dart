import 'package:flutter/widgets.dart';
import 'package:takkan_client/trait/trait_library.dart';
import 'package:takkan_script/part/navigation.dart';

class NavButtonTrait extends Trait {
  const NavButtonTrait({
    AlignmentGeometry alignment = AlignmentDirectional.center,
  }) : super(alignment: alignment);


}

class NavButtonSetTrait extends Trait {
  final String buttonTraitName;
  final double? width;
  final double? height;

  const NavButtonSetTrait({
    this.buttonTraitName = NavButton.defaultReadTrait,
    this.width = 150,
    this.height,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(alignment: alignment);

}
