import 'package:flutter/widgets.dart';
import 'package:precept_client/app/page/standardPage.dart';
import 'package:precept_client/page/errorPage.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/script/error.dart';
import 'package:precept_client/precept/script/script.dart';

class PageLibrary extends Library<String, Widget, PFormPage> {
  Widget Function(PError) _errorPage;

  @override
  init({Map<String, Widget Function(PFormPage)> entries, Widget Function(PError) errorPage}) {
    super.init(entries: entries);
    _errorPage = errorPage ?? (config) => PreceptDefaultErrorPage(config: config);
  }

  Widget errorPage(PError config) {
    return _errorPage(config);
  }

  @override
  setDefaults() {
    entries[Library.simpleKey] = (config) => DefaultPage(config: config);
  }
}


final PageLibrary _pageLibrary = PageLibrary();

PageLibrary get pageLibrary => _pageLibrary;
