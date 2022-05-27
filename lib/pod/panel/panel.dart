import 'package:flutter/material.dart';
import 'package:takkan_client/common/component/heading.dart';
import 'package:takkan_client/pod/pod_state.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:provider/provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_client/pod/page/standard_page.dart';
import 'package:takkan_script/panel/panel.dart';

///
/// [dataContext] provides access to data and associated functions
///
/// [pageArguments] are variable values passed through the page 'url' to the parent [TakkanPage] of this [PanelWidget]
class PanelWidget extends StatefulWidget {
  final Panel config;
  final DataContext dataContext;
  final Map<String, dynamic> pageArguments;

  const PanelWidget({
    super.key,
    required this.config,
    required this.dataContext,
    this.pageArguments = const {},
  });

  @override
  PanelWidgetState createState() => PanelWidgetState(
        config: config,
        pageArguments: pageArguments,
        parentDataContext: dataContext,
      );
}

///

///
/// A [PanelWidget] always relates to a single document, which is obtained via the [cache].
///
/// [DocumentCache] has a [DocumentClassCache] for each document class [cache]
/// is an instance of [DocumentClassCache], and contains the [dataProvider]
/// responsible for that document class.
///
/// Selection of the appropriate document class is determined by [config.documentClass].
///
/// The [IDataProvider] is mostly used to access the [TakkanUser] object it contains.
class PanelWidgetState extends PodState<PanelWidget> {
  final formKey = GlobalKey<FormState>();

  PanelWidgetState(
      {required Panel config,
      required DataContext parentDataContext,
      required Map<String, dynamic> pageArguments})
      : super(
          config: config,
          pageArguments: pageArguments,
          parentDataContext: parentDataContext,
        );
  late bool expanded;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return doBuild(context, theme);
  }

  Widget _expandedContent(ThemeData theme, bool editMode) {
    final content = buildSubContent(
      dataContext: dataContext,
      theme: theme,
      config: widget.config,
      pageArguments: widget.pageArguments,
    );

    return (editMode) ? wrapInForm(context, content, formKey) : content;
  }

  Widget assembleContent(ThemeData theme) {
    if (widget.config.heading != null) {
      return Heading(
        documentRoot: documentRoot,
        config: widget.config.heading!,
        headingText: widget.config.caption ?? '',
        expandedContent: (es) => _expandedContent(theme, es),
        dataContext: dataContext,
        openExpanded: true,
      );
    }
    final EditState editState = Provider.of<EditState>(context, listen: false);
    return Center(
        child: Container(child: _expandedContent(theme, editState.editMode)));
  }

  @override
  Widget layout(
      {required List<Widget> children,
      required Size screenSize,
      required Pod config}) {
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
      width: widget.config.layout.preferredColumnWidth,
    );
  }
}
