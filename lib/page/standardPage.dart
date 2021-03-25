import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/common/action/actionIcon.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
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
  const PreceptPage({@required this.config, this.pageArguments = const {}})
      : parentBinding = const NoDataBinding();

  @override
  PreceptPageState createState() => PreceptPageState(config, parentBinding);
}

class PreceptPageState extends ContentState<PreceptPage> {
  PreceptPageState(PContent config, DataBinding parentBinding) : super(config, parentBinding);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [PreceptRefreshButton()],
        title: Text(widget.config.title),
      ),
      body: doBuild(context, dataSource, widget.config, widget.pageArguments),
    );
  }

  @override
  Widget assembleContent() {
    return buildSubContent(
      content: widget.config.content,
      scrollable: widget.config.scrollable,
      parentBinding: dataBinding,
      pageArguments: widget.pageArguments,
    );
  }
}

class PreceptRefreshButton extends ActionIcon {
  @override
  void doAction(BuildContext context) {
    precept.reload();
  }

  const PreceptRefreshButton({
    Key key,
    IconData icon = Icons.update,
    List<Function(BuildContext)> onBefore = const [],
    List<Function(BuildContext)> onAfter = const [],
  }) : super(key: key, icon: icon, onAfter: onAfter, onBefore: onBefore);
}
