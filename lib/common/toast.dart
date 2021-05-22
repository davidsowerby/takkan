import 'package:precept_script/inject/inject.dart';

/// This uses the [injector] to enable testing - replacing [Toast] with a Mock via the injector
snackToast({required String text}) {
  inject<Toast>().snackToast(text: text);
}

class Toast {
  snackToast({required String text}) {
    // showToastWidget(KaymanSnackBar(text: text));  // TODO should toast be included?
  }
}
