import 'package:flutter/material.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_script/panel/panel.dart';

///
/// [dataContext] provides access to data and associated functions
///
/// [pageArguments] are variable values passed through the page 'url' to the parent [TakkanPage] of this [PanelWidget]
class PanelWidget extends StatefulWidget {
  final Panel config;
  final DataContext dataContext;
  final Map<String, dynamic> pageArguments;
  final CacheEntry cacheEntry;

  const PanelWidget({
    super.key,
    required this.config,
    required this.dataContext,
    required this.cacheEntry,
    this.pageArguments = const {},
  });

  @override
  PanelWidgetState createState() => PanelWidgetState(
        config: config,
        pageArguments: pageArguments,
        parentDataContext: dataContext,
      );
}

///

///
/// A [PanelWidget] always relates to a single document, which is obtained via the [cache].
///
/// [DocumentCache] has a [DocumentClassCache] for each document class [cache]
/// is an instance of [DocumentClassCache], and contains the [dataProvider]
/// responsible for that document class.
///
/// Selection of the appropriate document class is determined by [config.documentClass].
///
/// The [IDataProvider] is mostly used to access the [TakkanUser] object it contains.
class PanelWidgetState extends State<PanelWidget> {
  final formKey = GlobalKey<FormState>();

  PanelWidgetState(
      {required Panel config,
      required DataContext parentDataContext,
      required Map<String, dynamic> pageArguments});
  late bool expanded;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TBD'),
    );
  }
}
