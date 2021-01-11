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
  DataSource dataSource;
  DataBinding dataBinding;

  @override
  void initState() {
    super.initState();
    dataSource = DataSource(widget.config);
    dataBinding = widget.parentBinding.child(widget.config, widget.parentBinding, dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return doBuild(context, dataSource, widget.config, buildContent);
  }

  Widget _expandedContent() {
    final content = assembleContent(
      parentBinding: dataBinding,
      scrollable: widget.config.scrollable,
      content: widget.config.content,
    );
    return formWrapped(context, content, dataBinding);
  }

  Widget buildContent() {
    return Heading(
      headingText: widget.config.caption,
      expandedContent: _expandedContent,
      openExpanded: true,
      onAfterSave: [(_) => dataBinding.activeDataSource.persist(widget.config)],
    );
  }
}
