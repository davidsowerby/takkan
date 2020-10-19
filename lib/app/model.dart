import 'package:precept/precept/model/precept-signin.dart';
import 'package:precept/precept/model/precept.dart';

/// This is a temporary way of defining the Precept model for development only
///
Precept testModel() {
  return Precept((b) =>
  b
    ..signIn.backend = Backend.back4app
    ..signIn.brand = "wiggly"
    ..components.addAll([
      core(),
      common(),
      communicator(),
    ]));
}

PreceptComponent core() {
  return PreceptComponent((b) => b..name = "core");
}

PreceptComponent common() {
  return PreceptComponent((b) => b..name = "common");
}

PreceptComponent communicator() {
  return PreceptComponent((b) => b..name = "communicator");
}
