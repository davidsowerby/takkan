import 'package:flutter/widgets.dart';
import 'package:precept_client/trait/traitLibrary.dart';

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
