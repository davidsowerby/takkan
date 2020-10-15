import 'package:flutter/material.dart';
import 'package:precept/common/inject.dart';

/// This uses the [injector] to enable testing - replacing [Toast] with a Mock via the injector
snackToast({@required String text}) {
  injector<Toast>().snackToast(text: text);
}

class Toast {
  snackToast({@required String text}) {
    // showToastWidget(KaymanSnackBar(text: text));  // TODO should toast be included?
  }
}
