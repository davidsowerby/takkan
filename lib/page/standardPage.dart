import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/script/script.dart';

class PreceptPage extends StatefulWidget {
  final PPage config;

  const PreceptPage({@required this.config});

  @override
  _PreceptPageState createState() => _PreceptPageState();
}

class _PreceptPageState extends State<PreceptPage> with ContentBuilder implements ContentState {
  LocalContentState localState;

  @override
  void initState() {
    super.initState();
    localState = LocalContentState(widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
      ),
      body: doBuild(context, localState, widget.config, buildContent),
    );
  }

  @override
  Widget buildContent() {
    return PageBuilder().buildContent(context: context, config: widget.config);
  }
}
