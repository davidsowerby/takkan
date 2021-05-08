import 'package:flutter/material.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:provider/provider.dart';

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
  PanelState createState() => PanelState(config, parentBinding,pageArguments);
}

class PanelState extends ContentState<Panel, PPanel> {
  final formKey =GlobalKey<FormState>();

  PanelState(PContent config, DataBinding parentBinding,Map<String, dynamic> pageArguments) : super(config, parentBinding,pageArguments);
  bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return doBuild(context, theme,dataSource, widget.config, widget.pageArguments);
  }

  Widget _expandedContent(ThemeData theme, bool editMode) {
    final content = buildSubContent(
      theme:theme,
      config: widget.config,
      pageArguments: widget.pageArguments,
      parentBinding: dataBinding,
    );

    return (editMode) ? wrapInForm(context, content, dataBinding, formKey) : content;
  }

  Widget assembleContent(ThemeData theme) {
    if (widget.config.heading != null) {
      return Heading(
        config: widget.config.heading,
        headingText: widget.config.caption,
        expandedContent: (es) => _expandedContent(theme, es),
        dataBinding: dataBinding,
        openExpanded: true,
      );
    }
    final EditState editState = Provider.of<EditState>(context, listen: false);
    return Center(child: Container(child: _expandedContent(theme,editState.editMode)));
  }

  @override
  Widget layout({List<Widget> children, Size screenSize, PPanel config}) {
    final Widget wrapped = (widget.config.scrollable)
        ? ListView(
            children: children,
          )
        : Column(
            children: children,
          );
    return Container(child: wrapped, width: widget.config.layout.width,);
  }

  @override
  bool get preloaded => false;
}
