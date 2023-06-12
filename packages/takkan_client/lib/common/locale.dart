import 'package:flutter/material.dart';

/// Allows Mocking the retrieval of system Locale
abstract class LocaleReader {
  Locale systemLocale({void Function()? localeChangeListener});
}

class DefaultLocaleReader implements LocaleReader {
  @override
  Locale systemLocale({void Function()? localeChangeListener}) {
    final WidgetsBinding inst = WidgetsBinding.instance;
    final window = inst.window;
    final locale = window.locale;
    if (localeChangeListener != null) {
      window.onLocaleChanged = localeChangeListener;
    }
    return locale;
  }
}

/// Populates placeholders with [params]
mixin Interpolator {
  /// populates placeholders with [params]
  String interpolate(String pattern, {Map<String, dynamic>? params, Locale? locale}) {
    String p = pattern;
    if (params != null) {
      params.forEach((key, value) {
        p = p.replaceAll("{$key}", "$value");
      });
    }
    return p;
  }
}
