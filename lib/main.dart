import 'package:flutter/material.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/app/router.dart';

void main() {
  precept.init();
  runApp(PreceptApp());
}

class PreceptApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      onGenerateRoute: router.generateRoute,
    );
  }
}
