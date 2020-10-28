import 'package:flutter/foundation.dart';

abstract class PPart {
  final String caption;
  final String property;
  final bool readOnly;

  PPart({this.caption, @required this.property, this.readOnly = false});

  Map<String, dynamic> toJson();
}
