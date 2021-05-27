import 'package:precept_client/trait/traitLibrary.dart';
import 'package:precept_script/part/navigation.dart';

class NavigationButtonTrait extends Trait {
  const NavigationButtonTrait();


}

class NavigationButtonSetTrait extends Trait {
  final String buttonTraitName;
  final double? width;
  final double? height;

  const NavigationButtonSetTrait({
    this.buttonTraitName = PNavButton.defaultReadTrait,
    this.width=150,
    this.height,
  });

}
