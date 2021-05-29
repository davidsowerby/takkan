import 'package:flutter/widgets.dart';
import 'package:precept_client/trait/traitLibrary.dart';
import 'package:precept_script/part/navigation.dart';

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
    this.buttonTraitName = PNavButton.defaultReadTrait,
    this.width=150,
    this.height,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(alignment: alignment);

}
