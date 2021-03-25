import 'package:flutter/material.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_script/script/script.dart';

/// [pageArguments] are variable values passed through the page 'url' to the parent [PreceptPage] of this [Panel]
class Panel extends StatefulWidget {
  final PPanel config;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;

  const Panel(
      {Key key,
      @required this.config,
      this.pageArguments,
      this.parentBinding = const NoDataBinding()})
      : assert(config != null),
        assert(parentBinding != null);

  @override
  PanelState createState() => PanelState(config, parentBinding);
}

class PanelState extends ContentState<Panel> {
  PanelState(PContent config, DataBinding parentBinding) : super(config, parentBinding);
  bool expanded;

  @override
  Widget build(BuildContext context) {
    return doBuild(context, dataSource, widget.config, widget.pageArguments);
  }

  Widget _expandedContent(bool editMode) {
    final content = buildSubContent(
        content: widget.config.content,
        scrollable: widget.config.scrollable,
        pageArguments: widget.pageArguments,
        parentBinding: dataBinding);

    return (editMode) ? wrapInForm(context, content, dataBinding) : content;
  }

  Widget assembleContent() {
    return Heading(
      config: widget.config.heading,
      headingText: widget.config.caption,
      expandedContent: (es) => _expandedContent(es),
      dataSource: dataSource,
      openExpanded: true,
    );
  }
}
