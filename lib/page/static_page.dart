import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/page/layout/layout_wrapper.dart';
import 'package:takkan_client/page/standard_page.dart';
import 'package:takkan_script/page/static_page.dart';

/// A page displaying only static data, and therefore requiring no connection
/// to the [DocumentCache] for dynamic data.
///
/// It does still need [dataContext] to access authentication and user information
///
/// Currently assumes no authentication for a static page, which is wrong:
/// https://gitlab.com/takkan_/takkan_design/-/issues/21
class StaticPage extends StatelessWidget {
  final PageStatic config;
  final DataContext dataContext;
  final String route;
  final PageBuilder pageBuilder;

  const StaticPage({
    Key? key,
    required this.route,
    required this.config,
    required this.dataContext,
    required this.pageBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TakkanRefreshButton(),
          if (_canSignIn)
            IconButton(
              icon: Icon(FontAwesomeIcons.signOutAlt),
              onPressed: () => _doSignOut(context),
            )
        ],
        title: Text(config.title ?? ''),
      ),
      body: LayoutWrapper(
        config: config,
        dataContext: dataContext,
        parentBinding: NullDataBinding(),
        pageBuilder: pageBuilder,
      ),
    );
  }

  _doSignOut(BuildContext context) async {
    if (dataContext.dataProvider.authenticator.isAuthenticated) {
      await dataContext.dataProvider.authenticator.signOut();
      Navigator.of(context).pushNamed("/");
    }
  }

  bool get _canSignIn => !(dataContext is NullDataContext);
}
