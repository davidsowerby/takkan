import 'package:flutter/material.dart';
import 'package:precept_client/data/cache_entry.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/page/layout/layout_wrapper.dart';
import 'package:precept_client/pod/pod_builder.dart';
import 'package:precept_script/panel/panel.dart';

class StreamWrapper extends StatelessWidget {
  final PPod config;
  final DataContext dataContext;
  final CacheEntry cacheEntry;
  final DataBinding parentBinding;

  const StreamWrapper({
    Key? key,
    required this.dataContext,
    required this.cacheEntry,
    required this.config,
    required this.parentBinding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<Map<String, dynamic>>(
      stream: cacheEntry.stream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        List<Widget> children = createChildren(
          dataContext: dataContext,
          parentBinding: parentBinding,
          theme: theme,
          children: config.children,
        );

        return LayoutWrapper(
          config: config,
          children: children,
        );
      },
    );
  }
}
