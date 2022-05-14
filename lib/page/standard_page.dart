import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/common/action/action_icon.dart';
import 'package:precept_client/common/content/pod_state.dart';
import 'package:precept_client/convert/script.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/page/layout/layout.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/panel/panel.dart';

class PreceptPage extends StatefulWidget {
  final PPage config;
  final DataContext parentDataContext;
  final Map<String, dynamic> pageArguments;

  /// [parentDataContext] defaults to a [NullDataContext] as a top level page
  /// will have no parent.
  ///
  /// [pageArguments] are optional and are passed from the [RouteSettings] associated with the route
  /// producing this page.  Note that [RouteSettings.arguments] is an Object, but [pageArguments] requires
  /// a Map<String,dynamic>
  ///
  const PreceptPage({
    Key? key,
    required this.config,
    DataContext? parentDataContext,
    this.pageArguments = const {},
  })  : parentDataContext = parentDataContext ?? const NullDataContext(),
        super(key: key);

  @override
  PreceptPageState createState() => PreceptPageState(
    config: config,
        pageArguments: pageArguments,
        dataContext: parentDataContext,
      );
}

class PreceptPageState extends PodState<PreceptPage> with DisplayColumns {
  PreceptPageState({
    required PPage config,
    DataProvider? dataProvider,
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
    final padding = (config as PPage).layout.padding;
    return Padding(
      padding: padding.edgeInsets(),
      child: distributeWidgets(
          screenSize: screenSize,
          preferredColumnWidth: widget.config.layout.preferredColumnWidth,
          widgets: children),
    );
  }
}

class PreceptRefreshButton extends ActionIcon {
  @override
  void doAction(BuildContext context) {
    precept.reload();
  }

  const PreceptRefreshButton({
    Key? key,
    IconData icon = Icons.update,
    List<Function(BuildContext)> onBefore = const [],
    List<Function(BuildContext)> onAfter = const [],
  }) : super(key: key, icon: icon, onAfter: onAfter, onBefore: onBefore);
}
