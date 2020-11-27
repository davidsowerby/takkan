import 'package:flutter/widgets.dart';
import 'package:precept_client/app/page/standardPage.dart';
import 'package:precept_client/page/errorPage.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/model/error.dart';
import 'package:precept_client/precept/model/model.dart';

class PageLibrary extends Library<String, Widget, PPage> {
  Widget Function(PError) _errorPage;

  @override
  init(
      {List<LibraryModule<String, Widget, PPage>> modules,
        bool useDefault = true,
        Widget Function(PError) errorPage}) {
    super.init(modules: modules, useDefault: useDefault);
    if (errorPage != null) {
      _errorPage = errorPage ?? _defaultErrorPage;
    }
  }

  PreceptDefaultErrorPage _defaultErrorPage(PError config) {
    return PreceptDefaultErrorPage(config: config);
  }

  Widget errorPage(PError config) => _errorPage(config);

  @override
  Map<String, Widget Function(PPage)> get defaultMappings => DefaultPageLibraryModule().mappings;
}


class DefaultPageLibraryModule implements PageLibraryModule {
  StandardPage _standardPage(PPage config) {
    return StandardPage(config: config);
  }

  @override
  Map<String, Widget Function(PPage config)> get mappings {
    return {
      "standard": _standardPage,
    };
  }
}

abstract class PageLibraryModule extends LibraryModule<String, Widget, PPage> {}

final PageLibrary _pageLibrary=PageLibrary();
PageLibrary get pageLibrary=> _pageLibrary;