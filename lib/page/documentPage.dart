import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/script/script.dart';

class DefaultDocumentPage extends StatelessWidget {
  final PPage config;

  const DefaultDocumentPage({@required this.config, Key key}) :assert(config != null), super(key: key);

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
