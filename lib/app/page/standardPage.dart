import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/assembler/pageAssembler.dart';
import 'package:precept_client/precept/model/model.dart';

class StandardPage extends StatelessWidget {
  final PPage config;

  const StandardPage({@required this.config}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
      ),
        body: assemblePage(config: config),
    );
  }
}
