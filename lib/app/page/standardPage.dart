import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/model/model.dart';

class StandardPage extends StatelessWidget {
  final PRoute route;
  final PreceptPageAssembler pageAssembler;

  StandardPage({@required this.route}) : pageAssembler=inject<PreceptPageAssembler>();

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
