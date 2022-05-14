import 'package:flutter/widgets.dart';
import 'package:precept_script/common/script/layout.dart';

/// Extension functions to convert Prescript configuration elements to their
/// Flutter equivalent

extension PaddingFromPrecept on PPadding {
  EdgeInsetsGeometry edgeInsets() {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }
}
