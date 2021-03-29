import 'package:flutter/material.dart';
import 'package:precept_client/app/router.dart';


class PreceptApp extends StatelessWidget {
  final ThemeData theme;

  const PreceptApp({Key key, this.theme}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Precept',
      theme: theme,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      onGenerateRoute: (routeSettings) => router.generateRoute(routeSettings, context),
    );
  }
}
