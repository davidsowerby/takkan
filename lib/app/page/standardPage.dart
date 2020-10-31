import 'package:flutter/material.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/model/model.dart';

class StandardPage extends StatelessWidget {
  StandardPage({Key key, @required this.preceptRoute})
      : super(key: key);

  final PRoute preceptRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(preceptRoute.page.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: inject<PreceptPageAssembler>().assembleSections(route: preceptRoute),
        ),
      ),
    );
  }
}
