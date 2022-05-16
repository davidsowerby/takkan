import 'package:flutter/widgets.dart';
import 'package:takkan_client/trait/trait_library.dart';

class TextBoxTrait extends Trait {
  TextBoxTrait({
    bool showCaption = true,
    String? caption,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(
          showCaption: showCaption,
          alignment: alignment,
        );
}
