import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'file:///home/david/git/precept/precept_script/lib/script/script.dart';

class DefaultListPage extends StatelessWidget {
  final PPage config;

  const DefaultListPage({@required this.config, Key key}) :assert(config != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Precept Home"),
      ),
      body: Center(
        child: Container(
          child: Text("This will be a home page"),
        ),
      ),
    );
  }
}
