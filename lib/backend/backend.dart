import 'package:flutter/foundation.dart';
import 'package:precept_client/precept/script/backend.dart';

class Backend with ChangeNotifier {
  final PBackend config;

  Backend({this.config});
}
