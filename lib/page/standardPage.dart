import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/script.dart';

class PreceptPage extends StatefulWidget {
  final PPage config;

  const PreceptPage({@required this.config});

  @override
  _PreceptPageState createState() => _PreceptPageState();
}

class _PreceptPageState extends State<PreceptPage> with ContentBuilder implements ContentState {
  TemporaryDocument temporaryDocument;
  PDataSource dataSourceConfig;
  RootBinding rootBinding;
  final List<GlobalKey<FormState>> formKeys = List();

  @override
  void initState() {
    super.initState();
    if (widget.config.dataSourceIsDeclared) {
      temporaryDocument = inject<TemporaryDocument>();
      dataSourceConfig = widget.config.dataSource;
      rootBinding = temporaryDocument.rootBinding;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
      ),
      body: doBuild(context, temporaryDocument, widget.config, buildContent),
    );
  }

  @override
  Widget buildContent() {
    return PageBuilder().buildContent(context: context, config: widget.config);
  }
}
