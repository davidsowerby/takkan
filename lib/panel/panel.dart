import 'package:flutter/material.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/script.dart';

class Panel extends StatefulWidget {
  final PPanel config;

  Panel({Key key, @required this.config});

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with ContentBuilder implements ContentState {
  bool expanded;
  TemporaryDocument temporaryDocument;
  PDataSource dataSourceConfig;
  RootBinding rootBinding;
  final List<GlobalKey<FormState>> formKeys = List();

  @override
  void initState() {
    super.initState();
    expanded = widget.config.heading.openExpanded;
    if (widget.config.dataSourceIsDeclared) {
      temporaryDocument = inject<TemporaryDocument>();
      dataSourceConfig = widget.config.dataSource;
      rootBinding = temporaryDocument.rootBinding;
    }
  }

  @override
  Widget build(BuildContext context) {
    return doBuild(context, temporaryDocument, widget.config, buildContent);
  }

  Widget _expandedContent() {
    final content = PanelBuilder().buildContent(context: context, config: widget.config);
    return formWrapped(context, content, formKeys);
  }

  Widget buildContent() {
    return Heading(
      headingText: widget.config.caption,
      expandedContent: _expandedContent,
      openExpanded: true,
      onAfterSave: [(_) => persist(widget.config, temporaryDocument, formKeys)],
    );
  }
}
