import 'package:flutter/material.dart';
import 'package:takkan_client/app/router.dart';


class TakkanApp extends StatelessWidget {
  final ThemeData theme;

  const TakkanApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Takkan',
      theme: theme,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      onGenerateRoute: (routeSettings) => router.generateRoute(routeSettings, context),
    );
  }
}
