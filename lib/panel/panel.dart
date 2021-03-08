import 'package:flutter/material.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_script/script/script.dart';

class Panel extends StatefulWidget {
  final PPanel config;
  final DataBinding parentBinding;

  const Panel({Key key, @required this.config, this.parentBinding = const NoDataBinding()})
      : assert(config != null),
        assert(parentBinding != null);

  @override
  PanelState createState() => PanelState();
}

class PanelState extends State<Panel> with ContentBuilder implements ContentState {
  bool expanded;
  DataSource dataSource;
  DataBinding dataBinding;
  DataProvider dataProvider;

  PPanel get config => widget.config;

  @override
  void initState() {
    super.initState();
    if (config.dataProvider != null) {
      /// Call is not actioned if Precept already in ready state
      precept.addReadyListener ( _onPreceptReady);
      dataProvider = dataProviderLibrary.find(config: config.dataProvider);
    }
    dataSource = DataSource(config);
    dataBinding = widget.parentBinding.child(config, widget.parentBinding, dataSource);
    expanded=config.openExpanded;
  }

  _onPreceptReady() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return doBuild(context, dataSource, widget.config, buildContent);
  }

  Widget _expandedContent(bool editMode) {
    final content = assembleContent(
      parentBinding: dataBinding,
      scrollable: widget.config.scrollable,
      content: widget.config.content,
    );
    return (editMode) ? formWrapped(context, content, dataBinding) : content;
  }

  Widget buildContent() {
    return Heading(
      config: widget.config.heading,
      headingText: widget.config.caption,
      expandedContent: (es) => _expandedContent(es),
      dataSource: dataSource,
      openExpanded: true,
    );
  }
}
