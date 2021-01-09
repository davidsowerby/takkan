import 'package:flutter/material.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/script/script.dart';

class Panel extends StatefulWidget {
  final PPanel config;
  final DataBinding parentBinding;

  const Panel({Key key, @required this.config, this.parentBinding = const NoDataBinding()})
      : assert(config != null),
        assert(parentBinding != null);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with ContentBuilder implements ContentState {
  bool expanded;
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
    return doBuild(context, contentState, widget.config, buildContent);
  }

  Widget _expandedContent() {
    final content = assembleContent(
      parentBinding: dataBinding,
      scrollable: widget.config.scrollable,
      content: widget.config.content,
    );
    return formWrapped(context, content, contentState.formKeys);
  }

  Widget buildContent() {
    return Heading(
      headingText: widget.config.caption,
      expandedContent: _expandedContent,
      openExpanded: true,
      onAfterSave: [
            (_) => persist(widget.config, contentState.temporaryDocument, contentState.formKeys)
      ],
    );
  }
}
