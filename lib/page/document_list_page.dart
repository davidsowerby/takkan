import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_client/common/content/pod_state.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/page/document_page.dart';
import 'package:precept_client/page/layout/layout.dart';
import 'package:precept_client/page/standard_page.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/panel/panel.dart';

/// This could be used directly, but is generally used only by Precept to generate
/// pages automatically from [PScript]
///
/// Represents a page displaying 0..n pages of document class [config.documentClass]
///
/// To display a single of document, use [DocumentPage]
///
class DocumentListPage extends StatefulWidget {
  final PPage config;
  final Map<String, dynamic> pageArguments;
  final DataContext dataContext;
  final String route;
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

class DocumentListPageState extends PodState<DocumentListPage>
    with DisplayColumns {
  DocumentListPageState({
    required PPage config,
    DataProvider? dataProvider,
    Map<String, dynamic> pageArguments = const {},
  }) : super(
    parentDataContext: NullDataContext(),
          config: config,
          pageArguments: pageArguments,
        );

  @override
  Widget build(BuildContext context) {
    if (needsAuthentication) {
      return Center(child: CircularProgressIndicator());
    }
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PreceptRefreshButton(),
          IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () => _doSignOut(context),
          )
        ],
        title: Text(widget.config.title ?? ''),
      ),
      body: doBuild(
        context,
        theme,
      ),
    );
  }

  _doSignOut(BuildContext context) async {
    if (dataContext.dataProvider.authenticator.isAuthenticated) {
      await dataContext.dataProvider.authenticator.signOut();
      Navigator.of(context).pushNamed("/");
    }
  }

  @override
  Widget assembleContent(ThemeData theme) {
    return buildSubContent(
      dataContext: dataContext,
      theme: theme,
      config: widget.config,
      pageArguments: widget.pageArguments,
    );
  }

  /// Simple page layout :
  /// - Calculate the number of columns based on the width of the display, and allocate the children
  /// left to right
  /// - Add margin to each column as specified in [config.layout]
  ///
  /// This needs to be expanded to support more sophisticated layout options
  /// See https://gitlab.com/precept1/precept_client/-/issues/37
  Widget layout(
      {required List<Widget> children,
      required Size screenSize,
      required PPod config}) {
    final margins = (config as PPage).layout.margins;
    return Padding(
      padding: EdgeInsets.only(
        top: margins.top,
        bottom: margins.bottom,
        left: margins.left,
        right: margins.right,
      ),
      child: distributeWidgets(
          screenSize: screenSize,
          preferredColumnWidth: widget.config.layout.preferredColumnWidth,
          widgets: children),
    );
  }
}
