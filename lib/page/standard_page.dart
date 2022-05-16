import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takkan_client/app/takkan.dart';
import 'package:takkan_client/common/action/action_icon.dart';
import 'package:takkan_client/common/content/pod_state.dart';
import 'package:takkan_client/convert/script.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/page/layout/layout.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;
import 'package:takkan_script/panel/panel.dart';

class TakkanPage extends StatefulWidget {
  final PageConfig.Page config;
  final DataContext parentDataContext;
  final Map<String, dynamic> pageArguments;

  /// [parentDataContext] defaults to a [NullDataContext] as a top level page
  /// will have no parent.
  ///
  /// [pageArguments] are optional and are passed from the [RouteSettings] associated with the route
  /// producing this page.  Note that [RouteSettings.arguments] is an Object, but [pageArguments] requires
  /// a Map<String,dynamic>
  ///
  const TakkanPage({
    Key? key,
    required this.config,
    DataContext? parentDataContext,
    this.pageArguments = const {},
  })  : parentDataContext = parentDataContext ?? const NullDataContext(),
        super(key: key);

  @override
  TakkanPageState createState() => TakkanPageState(
    config: config,
        pageArguments: pageArguments,
        dataContext: parentDataContext,
      );
}

class TakkanPageState extends PodState<TakkanPage> with DisplayColumns {
  TakkanPageState({
    required PageConfig.Page config,
    IDataProvider? dataProvider,
    required DataContext dataContext,
    Map<String, dynamic> pageArguments = const {},
  }) : super(
    parentDataContext: dataContext,
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
          TakkanRefreshButton(),
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
  /// See https://gitlab.com/takkan_/takkan_client/-/issues/37
  Widget layout(
      {required List<Widget> children,
      required Size screenSize,
      required Pod config}) {
    final padding = (config as PageConfig.Page).layout.padding;
    return Padding(
      padding: padding.edgeInsets(),
      child: distributeWidgets(
          screenSize: screenSize,
          preferredColumnWidth: widget.config.layout.preferredColumnWidth,
          widgets: children),
    );
  }
}

class TakkanRefreshButton extends ActionIcon {
  @override
  void doAction(BuildContext context) {
    takkan.reload();
  }

  const TakkanRefreshButton({
    Key? key,
    IconData icon = Icons.update,
    List<Function(BuildContext)> onBefore = const [],
    List<Function(BuildContext)> onAfter = const [],
  }) : super(key: key, icon: icon, onAfter: onAfter, onBefore: onBefore);
}
