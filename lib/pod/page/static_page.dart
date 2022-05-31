import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/pod/layout/layout_wrapper.dart';
import 'package:takkan_client/pod/page/standard_page.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;

/// A page displaying only static data, and therefore requiring no connection
/// to the [DocumentCache] for dynamic data.
///
/// It does still need [dataContext] to access authentication and user information
///
/// Currently assumes no authentication for a static page, which is wrong:
/// https://gitlab.com/precept1/precept_design/-/issues/21
class StaticPage extends StatelessWidget {
  final PageConfig.Page config;
  final DataContext dataContext;
  final String route;
  final PageBuilder pageBuilder;
  final Map<String, dynamic> pageArguments;

  const StaticPage({
    Key? key,
    required this.route,
    required this.config,
    required this.dataContext,
    required this.pageBuilder,
    required this.pageArguments,
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
        pageArguments: pageArguments,
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
