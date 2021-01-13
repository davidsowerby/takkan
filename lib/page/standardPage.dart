import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/script/script.dart';

class PreceptPage extends StatefulWidget {
  final PPage config;
  final DataBinding parentBinding;

  /// [parentBinding] is always a [NoDataBinding] for a page, because there is nothing relating to
  /// Precept data above it in the Widget tree.
  ///
  /// Doing it this way keeps the structure consistent with [Panel] and [Part]
  const PreceptPage({@required this.config}) : parentBinding = const NoDataBinding();

  @override
  PreceptPageState createState() => PreceptPageState();
}

class PreceptPageState extends State<PreceptPage> with ContentBuilder implements ContentState {
  DataSource dataSource;
  DataBinding dataBinding;

  PCommon get config => widget.config;

  @override
  void initState() {
    super.initState();
    dataSource = DataSource(widget.config);
    dataBinding = widget.parentBinding.child(widget.config, widget.parentBinding, dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
      ),
      body: doBuild(context, dataSource, widget.config, buildContent),
    );
  }

  @override
  Widget buildContent() {
    return assembleContent(
        content: widget.config.content,
        scrollable: widget.config.scrollable,
        parentBinding: dataBinding);
  }
}
