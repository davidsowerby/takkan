import 'package:flutter/widgets.dart';

/// Organises display columns according to screen size
mixin DisplayColumns {
  /// Distributes [widgets] across available columns.  The number of available columns is determined by [screenSize.width]
  /// divided by the [preferredColumnWidth].
  ///
  /// The actual column width used uses all available screen space.
  ///
  /// If screen width is less than [preferredColumnWidth], actual column width is set to screen width.  Outstanding
  /// issue #258 to warn user when their screen is narrower than [preferredColumnWidth]
  ///
  Row distributeWidgets(
      {required Size screenSize, required double preferredColumnWidth, required List<Widget> widgets}) {
    final dim = dimensions(screenSize: screenSize, preferredColumnWidth: preferredColumnWidth);
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

  singleColumn({required Size screenSize, required double preferredColumnWidth, required List<Widget> widgets}) {
    final dim = dimensions(screenSize: screenSize, preferredColumnWidth: preferredColumnWidth);
    return Container(
      width: dim.columnWidth,
      child: ListView(
        children: widgets,
      ),
    );
  }

  /// Returns calculated [DisplayColumnDimensions] from [screenSize] and [preferredColumnWidth].  If [ screenSize.width]
  /// is less than [preferredColumnWidth], the [DisplayColumnDimensions.screenLessThanPreferredWidth] flag is set.
  /// (see issue #258)
  DisplayColumnDimensions dimensions({required Size screenSize, double preferredColumnWidth = 360}) {
    if (screenSize.width < preferredColumnWidth) {
      return DisplayColumnDimensions(
          numberOfColumns: 1, columnWidth: screenSize.width, screenLessThanPreferredWidth: true);
    }
    final int numOfColumns = screenSize.width ~/ preferredColumnWidth;
    return DisplayColumnDimensions(numberOfColumns: numOfColumns, columnWidth: screenSize.width / numOfColumns);
  }
}

class DisplayColumnDimensions {
  final int numberOfColumns;
  final double columnWidth;
  final bool screenLessThanPreferredWidth;

  const DisplayColumnDimensions(
      {required this.numberOfColumns, required this.columnWidth, this.screenLessThanPreferredWidth = false});
}