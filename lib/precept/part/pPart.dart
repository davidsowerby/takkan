import 'package:flutter/foundation.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/part.dart';

/// Contained within a [PreceptModel] a [PPart] describes a [Part]
abstract class PPart {
  final String caption;
  final String property;
  final bool readOnly;

  /// [readOnly], if true, forces this part always to be in read only mode, regardless of any other settings
  PPart({this.caption, @required this.property, this.readOnly = false});

  Map<String, dynamic> toJson();
}
