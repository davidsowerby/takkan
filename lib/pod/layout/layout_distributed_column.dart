import 'package:flutter/material.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/pod/layout/layout_wrapper.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/script/content.dart';
import 'package:takkan_script/script/layout.dart';

class LayoutDistributedColumn implements PageLayout {
  final Pod podConfig;
  final Layout layoutConfig;
  final DataContext dataContext;
  final DataBinding parentBinding;
  final ThemeData theme;

  const LayoutDistributedColumn({
    required this.layoutConfig,
    required this.podConfig,
    required this.dataContext,
    required this.parentBinding,
    required this.theme,
  });

  @override
  Widget assemble({
    required BuildContext context,
    required BoxConstraints constraints,
    required Map<String, dynamic> pageArguments,
  }) {
    return distributeWidgets(
      constraints: constraints,
      context: context,
      pageArguments: pageArguments,
    );
  }

  Row distributeWidgets({
    required BoxConstraints constraints,
    required BuildContext context,
    required Map<String, dynamic> pageArguments,
  }) {
    final widgets = podConfig.children;
    final pageBuilder = inject<PageBuilder>();
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
              theme: theme,
              pageArguments: pageArguments,
            );
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
