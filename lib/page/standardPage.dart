import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/common/action/actionIcon.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/common/page/layout.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/script/script.dart';

class PreceptPage extends StatefulWidget {
  final PPage config;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;

  /// [parentBinding] is always a [NoDataBinding] for a page, because there is nothing relating to
  /// Precept data above it in the Widget tree.
  ///
  /// [pageArguments] are optional and are passed from the [RouteSettings] associated with the route
  /// producing this page.  Note that [RouteSettings.arguments] is an Object, but [pageArguments] requires
  /// a Map<String,dynamic>
  ///
  /// Doing it this way keeps the structure consistent with [Panel] and [Part]
  const PreceptPage({required this.config, this.pageArguments = const {}})
      : parentBinding = const NoDataBinding();

  @override
  PreceptPageState createState() => PreceptPageState(config, parentBinding, pageArguments);
}

class PreceptPageState extends ContentState<PreceptPage, PPage> with DisplayColumns {
  PreceptPageState(PContent config, DataBinding parentBinding, Map<String, dynamic> pageArguments)
      : super(config, parentBinding, pageArguments);

  @override
  void initState() {
    super.initState();
  }

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
      body: doBuild(context, theme, dataSource, widget.config, widget.pageArguments),
    );
  }

  _doSignOut(BuildContext context) async {
    if (dataProvider != null) {
      if (dataProvider.authenticator.isAuthenticated) {
        await dataProvider.authenticator.signOut();
        Navigator.of(context).pushNamed("/");
      }
    }
  }

  @override
  Widget assembleContent(ThemeData theme) {
    return buildSubContent(
      theme: theme,
      config: widget.config,
      parentBinding: dataBinding,
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
  Widget layout({required List<Widget> children, required Size screenSize, required PPage config}) {
    final margins = config.layout.margins;
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
