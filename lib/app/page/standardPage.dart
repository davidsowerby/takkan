import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/assembler.dart';
import 'package:precept_client/precept/model/model.dart';

class StandardPage extends StatelessWidget {
  final PRoute route;
  final PageBuilder pageAssembler;

  StandardPage({@required this.route}) : pageAssembler=inject<PageBuilder>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(route.page.title),
      ),
        body: Column(children:pageAssembler.assembleElements(elements: route.page.document.sections)),
    );
  }
}
