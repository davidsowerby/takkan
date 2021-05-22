import 'package:flutter/material.dart';
import 'package:precept_client/common/locale.dart';

class MockLocaleReader implements LocaleReader {
  final Locale locale;

  const MockLocaleReader(this.locale);

  @override
  Locale systemLocale({void Function()? localeChangeListener}) {
    return locale;
  }
}
