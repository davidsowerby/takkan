import 'package:flutter/material.dart';
import 'package:precept/app/inject/setupInject.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/precept.dart';
import 'package:precept/precept/router.dart';

void main() {
  setupInjector(injectorBindings);
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
