import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/model/error.dart';

class PreceptDefaultErrorPage extends StatelessWidget {
  final PError config;

  const PreceptDefaultErrorPage({@required this.config, Key key}) :assert(config != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Precept Error"),
      ),
      body: Center(
        child: Container(
          child: Text(config.message),
        ),
      ),
    );
  }
}
