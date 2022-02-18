import 'package:flutter/material.dart';
import 'package:precept_client/trait/trait_library.dart';

class TextTrait extends Trait {
  final TextStyle textStyle;
  final TextAlign textAlign;
  final TextTheme textTheme;

  const TextTrait(
      {required this.textStyle,
      required this.textAlign,
      required this.textTheme,
      AlignmentGeometry alignment = AlignmentDirectional.centerStart,
      bool showCaption = true})
      : super(
          showCaption: showCaption,
          alignment: alignment,
        );
}
