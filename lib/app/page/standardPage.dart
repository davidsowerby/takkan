import 'package:flutter/material.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/section/base/section.dart';

class StandardPage extends StatelessWidget {
  StandardPage({Key key, @required this.sections, this.preceptPage})
      : super(key: key);

  final List<Section> sections;
  final PPage preceptPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(preceptPage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sections,
        ),
      ),
    );
  }
}
