import 'package:flutter/widgets.dart';
import 'package:precept_client/library/library.dart';
import 'package:precept_client/page/errorPage.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_script/script/error.dart';
import 'package:precept_script/script/script.dart';

class PageLibrary extends Library<String, Widget, PPage> {
  Widget Function(PError) _errorPage;

  @override
  init({Map<String, Widget Function(PPage)> entries, Widget Function(PError) errorPage}) {
    super.init(entries: entries);
    _errorPage = errorPage ?? (config) => PreceptDefaultErrorPage(config: config);
  }

  Widget errorPage(PError config) {
    return _errorPage(config);
  }

  @override
  setDefaults() {
    entries[Library.simpleKey] = (config) => PreceptPage(config: config);
  }
}


final PageLibrary _pageLibrary = PageLibrary();

PageLibrary get pageLibrary => _pageLibrary;
