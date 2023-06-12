import 'package:flutter/material.dart';
import 'package:takkan_client/app/router.dart';
import 'package:takkan_script/page/page.dart';


class TakkanApp extends StatelessWidget {
  final ThemeData theme;
  final String initialRoute;

  const TakkanApp({super.key, required this.theme, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Takkan',
      theme: theme,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: TakkanRoute.fromString(initialRoute).toString(),
      onGenerateRoute: (routeSettings) => router.generateRoute(routeSettings, context),
    );
  }
}
