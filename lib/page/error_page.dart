import 'package:flutter/material.dart';
import 'package:precept_script/common/script/error.dart';

class PreceptDefaultErrorPage extends StatelessWidget {
  final PError config;

  const PreceptDefaultErrorPage({required this.config, Key? key}) : super(key: key);

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
