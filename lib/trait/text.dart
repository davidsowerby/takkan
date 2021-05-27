import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:precept_client/trait/traitLibrary.dart';

class TextTrait extends Trait {
  final TextStyle textStyle;
  final TextAlign textAlign;
  final TextTheme textTheme;

  const TextTrait(
      {required this.textStyle,
        required this.textAlign,
        required this.textTheme,
        bool showCaption = true})
      : super(showCaption: showCaption);


}