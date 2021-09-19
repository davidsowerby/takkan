import 'package:flutter/material.dart';
import 'package:precept_client/app/app.dart';
import 'package:precept_client/app/loader.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_tutorial/app/config/precept.dart';

void main() async {
  await precept.init(
    loaders: [
      DirectPreceptLoader(script: myScript),
    ],
  );
  final ThemeData theme = ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  runApp(PreceptApp(theme: theme));
}
