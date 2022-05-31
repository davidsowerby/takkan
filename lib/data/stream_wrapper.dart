import 'package:flutter/material.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/pod/layout/layout_wrapper.dart';
import 'package:takkan_script/panel/panel.dart';

class StreamWrapper extends StatelessWidget {
  final Pod config;
  final DataContext dataContext;
  final CacheEntry cacheEntry;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;

  const StreamWrapper({
    Key? key,
    required this.dataContext,
    required this.cacheEntry,
    required this.config,
    required this.parentBinding,
    required this.pageArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: cacheEntry.stream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        return LayoutWrapper(
          config: config,
          parentBinding: parentBinding,
          dataContext: dataContext,
          pageArguments: pageArguments,
        );
      },
    );
  }
}
