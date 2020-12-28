import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_script/script/script.dart';

class PreceptPage extends StatelessWidget {
  final PPage config;

  const PreceptPage({@required this.config}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
      ),
        body: PageBuilder().buildContent(context: context,config: config),
    );
  }
}
