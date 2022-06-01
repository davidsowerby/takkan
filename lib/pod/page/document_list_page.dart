import 'package:flutter/material.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/pod/page/document_page.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;

import '../../common/component/takkan_refresh_button.dart';

/// This could be used directly, but is generally used only by Takkan to generate
/// pages automatically from [Script]
///
/// Represents a page displaying 0..n pages of document class [config.documentClass]
///
/// To display a single of document, use [DocumentPage]
///
class DocumentListPage extends StatefulWidget {
  final PageConfig.Page config;
  final Map<String, dynamic> pageArguments;
  final DataContext dataContext;
  final PageConfig.TakkanRoute route;
  final List<String>? objectIds;

  /// [dataContext] defaults to a [NullDataContext] when used as a top level page,
  /// as it will have no parent..
  ///
  /// [pageArguments] are optional and are passed from the [RouteSettings] associated with the route
  /// producing this page.  Note that [RouteSettings.arguments] is an Object, but [pageArguments] requires
  /// a Map<String,dynamic>
  ///
  const DocumentListPage({
    Key? key,
    required this.config,
    required this.dataContext,
    required this.route,
    this.objectIds,
    this.pageArguments = const {},
  }) : super(key: key);

  @override
  DocumentListPageState createState() => DocumentListPageState(
        config: config,
        pageArguments: pageArguments,
      );
}

class DocumentListPageState extends State<DocumentListPage>
  {
  DocumentListPageState({
    required PageConfig.Page config,
    IDataProvider? dataProvider,
    Map<String, dynamic> pageArguments = const {},
  }) ;

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TakkanRefreshButton(),

        ],
        title: Text(widget.config.title ?? ''),
      ),
      body: Center(child: Text('TBD'),)
    );
  }


}
