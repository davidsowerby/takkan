import 'package:flutter/widgets.dart';
import 'package:precept_client/page/layout/layout_wrapper.dart';
import 'package:precept_script/common/script/layout.dart';

class LayoutByColumn implements PageLayout {
  final PLayout config;
  final List<Widget> children;

  const LayoutByColumn({required this.config, required this.children});

  @override
  Widget assemble(BuildContext context, BoxConstraints constraints) {
    return distributeWidgets(constraints: constraints, widgets: children);
  }

  Row distributeWidgets(
      {required BoxConstraints constraints, required List<Widget> widgets}) {
    final dim = dimensions(
        constraints: constraints,
        preferredColumnWidth: config.preferredColumnWidth);
    final List<List<Widget>> columnChildren = List.empty(growable: true);
    for (int i = 0; i < dim.numberOfColumns; i++) {
      columnChildren.add(List<Widget>.empty(growable: true));
    }

    for (int i = 0; i < widgets.length; i++) {
      int targetColumn = i % dim.numberOfColumns;
      columnChildren[targetColumn].add(widgets[i]);
    }
    final views = List<Widget>.empty(growable: true);
    for (int i = 0; i < dim.numberOfColumns; i++) {
      views.add(Container(
          width: dim.columnWidth,
          child: ListView(
            children: columnChildren[i],
          )));
    }
    return Row(children: views);
  }

  /// Returns calculated [DisplayColumnDimensions] from [screenSize] and [preferredColumnWidth].  If [ screenSize.width]
  /// is less than [preferredColumnWidth], the [DisplayColumnDimensions.screenLessThanPreferredWidth] flag is set.
  /// (see issue #258)
  DisplayColumnDimensions dimensions(
      {required BoxConstraints constraints,
      double preferredColumnWidth = 360}) {
    if (constraints.maxWidth < preferredColumnWidth) {
      return DisplayColumnDimensions(
          numberOfColumns: 1,
          columnWidth: constraints.maxWidth,
          screenLessThanPreferredWidth: true);
    }
    final int numOfColumns = constraints.maxWidth ~/ preferredColumnWidth;
    return DisplayColumnDimensions(
        numberOfColumns: numOfColumns,
        columnWidth: constraints.maxWidth / numOfColumns);
  }
}

class DisplayColumnDimensions {
  final int numberOfColumns;
  final double columnWidth;
  final bool screenLessThanPreferredWidth;

  const DisplayColumnDimensions(
      {required this.numberOfColumns,
      required this.columnWidth,
      this.screenLessThanPreferredWidth = false});
}
