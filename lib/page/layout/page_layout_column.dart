import 'package:flutter/material.dart';
import 'package:precept_client/app/page_builder.dart';
import 'package:precept_client/data/cache_entry.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/page/layout/layout_wrapper.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/panel/panel.dart';

class LayoutDistributedColumn implements PageLayout {
  final Pod podConfig;
  final Layout layoutConfig;
  final DataContext dataContext;
  final DataBinding parentBinding;
  final ThemeData theme;
  final PageBuilder pageBuilder;

  const LayoutDistributedColumn({
    required this.layoutConfig,
    required this.podConfig,
    required this.dataContext,
    required this.parentBinding,
    required this.theme,
    required this.pageBuilder,
  });

  @override
  Widget assemble(BuildContext context, BoxConstraints constraints) {
    return distributeWidgets(constraints: constraints, context: context);
  }

  Row distributeWidgets({
    required BoxConstraints constraints,
    required BuildContext context,
  }) {
    final widgets = podConfig.children;

    final dim = dimensions(
      constraints: constraints,
      preferredColumnWidth: layoutConfig.preferredColumnWidth,
    );

    final List<Container> columns = List.empty(growable: true);
    final List<List<Content>> distributedContent = List.empty(growable: true);
    int numCols = dim.numberOfColumns;
    for (int k = 0; k < numCols; k++) {
      distributedContent.add(List.empty(growable: true));
    }

    /// Populate each distributedContent in turn with a widget config
    /// grouping together any held in a PGroup
    for (int k = 0; k < widgets.length; k++) {
      final col = k % numCols;
      if (widgets[k] is Group) {
        final Group group = widgets[k] as Group;
        distributedContent[col].addAll(group.children);
      } else {
        distributedContent[col].add(widgets[k]);
      }
    }

    /// Now build the ListViews from them
    for (int k = 0; k < numCols; k++) {
      final content = distributedContent[k];
      final container = Container(
        width: dim.columnWidth,
        height: constraints.maxHeight,
        child: ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            return pageBuilder.createChild(
                dataContext: dataContext,
                p: content[index],
                parentBinding: parentBinding,
                theme: theme);
          },
        ),
      );
      columns.add(container);
    }

    return Row(children: columns);
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
