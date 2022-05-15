import 'package:flutter/widgets.dart';
import 'package:precept_script/common/script/layout.dart' as LayoutConfig;

/// Extension functions to convert Prescript configuration elements to their
/// Flutter equivalent

extension PaddingFromPrecept on LayoutConfig.Padding {
  EdgeInsetsGeometry edgeInsets() {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }
}
