import 'package:flutter/material.dart';
import 'package:takkan_script/script/error.dart';

class TakkanDefaultErrorPage extends StatelessWidget {
  final TakkanError config;

  const TakkanDefaultErrorPage({required this.config, Key? key})
      : super(key: key);

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
