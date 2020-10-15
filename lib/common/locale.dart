import 'package:flutter/material.dart';

/// Allows Mocking the retrieval of system Locale
abstract class LocaleReader {
  Locale systemLocale({void Function() localeChangeListener});
}

class DefaultLocaleReader implements LocaleReader {
  @override
  Locale systemLocale({void Function() localeChangeListener}) {
    final window = WidgetsBinding.instance.window;
    final locale = window.locale;
    if (localeChangeListener != null) {
      window.onLocaleChanged = localeChangeListener;
    }
    return locale;
  }
}
