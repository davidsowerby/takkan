import 'package:flutter/material.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/app/router.dart';
import 'package:precept_client/user/userState.dart';
import 'package:provider/provider.dart';

void main() {
  precept.init();
  runApp(PreceptApp());
}

/// [UserState] needs to be at the top of the application, it is used by the router
class PreceptApp extends StatelessWidget {
  final UserState userState=UserState();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
      create: (_) => userState,
      child: MaterialApp(
        title: 'Precept',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: '/',
        onGenerateRoute: (routeSettings) => router.generateRoute(routeSettings, userState),
      ),
    );
  }
}
