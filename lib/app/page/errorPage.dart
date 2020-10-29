import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({Key key, @required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
    );
  }
}
