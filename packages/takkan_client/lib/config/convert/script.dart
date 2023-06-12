import 'package:flutter/widgets.dart';
import 'package:takkan_script/script/layout.dart' as LayoutConfig;

/// Extension functions to convert Prescript configuration elements to their
/// Flutter equivalent

extension PaddingFromTakkan on LayoutConfig.Padding {
  EdgeInsetsGeometry edgeInsets() {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }
}
