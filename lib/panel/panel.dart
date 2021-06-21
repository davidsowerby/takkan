import 'package:flutter/material.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:provider/provider.dart';

///
/// [parentDataProvider] gives access to the 'nearest' [DataProvider] up the widget tree.  This will
/// be overridden if a data provider is declared at the level of this Panel (that is, the [PPanel]
/// in [config] contains a [PDataProvider]).  The [DataProvider] contains a [PreceptUser] object
/// relating to that provider, and access may therefore be required in any [Panel] or [Part].
///
/// [parentBinding] provides access to the chain of data bindings leading back to the 'nearest' [DataSource]
/// up the widget tree.  This will be overridden if a new [DataSource] is declared in [config].
///
/// [pageArguments] are variable values passed through the page 'url' to the parent [PreceptPage] of this [Panel]
class Panel extends StatefulWidget {
  final PPanel config;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;
  final DataProvider parentDataProvider;

  const Panel(
      {Key? key,
      required this.config,
      required this.pageArguments,
      required this.parentDataProvider,
      this.parentBinding = const NoDataBinding()})
      : super(key: key);

  @override
  PanelState createState() => PanelState(config, parentBinding, parentDataProvider, pageArguments);
}

class PanelState extends ContentState<Panel, PPanel> {
  final formKey = GlobalKey<FormState>();

  PanelState(PContent config, DataBinding parentBinding, DataProvider parentDataProvider,
      Map<String, dynamic> pageArguments)
      : super(config, parentBinding, parentDataProvider, pageArguments);
  late bool expanded;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return doBuild(context, theme, dataSource, widget.config, widget.pageArguments);
  }

  Widget _expandedContent(ThemeData theme, bool editMode) {
    final content = buildSubContent(
      parentDataProvider: widget.parentDataProvider,
      theme: theme,
      config: widget.config,
      pageArguments: widget.pageArguments,
      parentBinding: dataBinding,
    );

    return (editMode) ? wrapInForm(context, content, dataBinding, formKey) : content;
  }

  Widget assembleContent(ThemeData theme) {
    if (widget.config.heading != null) {
      return Heading(
        config: widget.config.heading!,
        headingText: widget.config.caption ?? '',
        expandedContent: (es) => _expandedContent(theme, es),
        dataBinding: dataBinding,
        openExpanded: true,
      );
    }
    final EditState editState = Provider.of<EditState>(context, listen: false);
    return Center(child: Container(child: _expandedContent(theme, editState.editMode)));
  }

  @override
  Widget layout(
      {required List<Widget> children, required Size screenSize, required PPanel config}) {
    final Widget wrapped = (widget.config.scrollable)
        ? ListView(
            children: children,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
    return Container(
      child: wrapped,
      width: widget.config.layout.width,
    );
  }

  @override
  bool get preloaded => false;
}
