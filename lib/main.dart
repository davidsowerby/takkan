import 'package:flutter/material.dart';
import 'package:precept_backend/backend/user/userState.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/app/router.dart';

void main() {
  precept.init();
  runApp(PreceptApp());
}

/// [UserState] needs to be at the top of the application, it is used by the router
class PreceptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Precept',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      onGenerateRoute: (routeSettings) => router.generateRoute(routeSettings, context),
    );
  }
}
