import 'package:flutter/widgets.dart';
import 'package:precept_client/common/component/nav/navButton.dart';

/// Provides a centred [Container] set to [width] and [height], wrapping a [Column] of [NavigationButton] as defined by [children]
///
class NavigationButtonSet extends StatelessWidget {
  final List<NavigationButton> children;
  final double width;
  final double height;

  const NavigationButtonSet({Key key, @required this.children, this.width = 150, this.height = 150})
      : assert(children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}