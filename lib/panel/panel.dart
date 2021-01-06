import 'package:flutter/material.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/script/script.dart';

class Panel extends StatefulWidget {
  final PPanel config;

  Panel({Key key, @required this.config});

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with ContentBuilder implements ContentState {
  bool expanded;
  LocalContentState localState;

  @override
  void initState() {
    super.initState();
    localState = LocalContentState(widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return doBuild(context, localState.temporaryDocument, widget.config, buildContent);
  }

  Widget _expandedContent() {
    final content = PanelBuilder().buildContent(context: context, config: widget.config);
    return formWrapped(context, content, localState.formKeys);
  }

  Widget buildContent() {
    return Heading(
      headingText: widget.config.caption,
      expandedContent: _expandedContent,
      openExpanded: true,
      onAfterSave: [
        (_) => persist(widget.config, localState.temporaryDocument, localState.formKeys)
      ],
    );
  }
}
