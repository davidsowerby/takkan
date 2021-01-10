import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/script/script.dart';

class PreceptPage extends StatefulWidget {
  final PPage config;
  final DataBinding parentBinding;

  /// [parentBinding] is always a [NoDataBinding] for a page, because there is nothing relating to
  /// Precept data above it in the Widget tree.
  ///
  /// Doing it this wasy keeps the structure consistent with [Panel] and [Part]
  const PreceptPage({@required this.config}) : parentBinding = const NoDataBinding();

  @override
  _PreceptPageState createState() => _PreceptPageState();
}

class _PreceptPageState extends State<PreceptPage> with ContentBuilder implements ContentState {
  LocalContentState contentState;
  DataBinding dataBinding;

  @override
  void initState() {
    super.initState();
    contentState = LocalContentState(widget.config);
    dataBinding = widget.parentBinding.child(widget.config, widget.parentBinding, contentState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
      ),
      body: doBuild(context, contentState, widget.config, buildContent),
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
