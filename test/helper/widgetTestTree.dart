import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/app/page/standardPage.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/library/backendLibrary.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_client/precept/library/panelLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/panel/panel.dart';
import 'package:precept_client/precept/part/part.dart';
import 'package:precept_script/common/logger.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

import './exception.dart';

/// [pages], [panels] & [parts] are the number of each expected to be found.  This is checked by calling [verify]
class WidgetTestTree {
  final List<Widget> widgets;
  final List<String> elementDebugs=List();
  final int pages;
  final int panels;
  final int parts;

  WidgetTestTree(this.widgets, {this.pages = 1, this.panels = 2, this.parts = 6}) {
    _scan();
  }

  Map<String, int> _panelIndexes = Map();
  Map<String, int> _partIndexes = Map();
  Map<String, int> _pageIndexes = Map();
  Map<String, int> _allIndexes = Map();

  final List<String> debug = List();

  _scan() {
    int index = 0;
    for (Widget widget in widgets) {
      if (widget is PreceptPage) {
        _pageIndexes[widget.config.debugId] = index;
        _allIndexes[widget.config.debugId] = index;
        elementDebugs.add(widget.config.debugId);

      } else if (widget is Panel) {
        _panelIndexes[widget.config.debugId] = index;
        _allIndexes[widget.config.debugId] = index;
        elementDebugs.add(widget.config.debugId);
      } else if (widget is Part) {
        _partIndexes[widget.config.debugId] = index;
        _allIndexes[widget.config.debugId] = index;
        elementDebugs.add(widget.config.debugId);
      }
      index++;
    }
  }

  int _upFromElement(int startIndex, bool Function(Widget) typeTest) {
    int index = startIndex;
    bool itemFound = false;
    while (index >= 0 && !itemFound) {
      if (typeTest(widgets[index])) {
        return index;
      }
      index--;
    }
    return -1;
  }

  bool elementHas(String id, bool Function(Widget) typeTest, Type lookingFor) {
    final index = _allIndexes[id];
    if (index == null) {
      String msg = "${this.runtimeType.toString()} cannot find '$id'. The _scan did not find it";
      logType(this.runtimeType).e("");
      debug.add(msg);
      throw TestException(msg);
    }
    int result = _upFromElement(index, typeTest);
    bool found = result >= 0;
    String text = (found) ? "found at $result" : 'NOT found';
    debug.add("Looking for ${lookingFor.toString()} in $id:  $text");
    return found;
  }

  bool elementHasEditState(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<EditState>, EditState);
  }

  bool elementHasPanelState(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<PanelState>, PanelState);
  }

  bool elementHasDataBinding(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<DataBinding>, DataBinding);
  }

  bool elementHasDataSource(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<DataSource>, DataSource);
  }

  verify() {
    bool pagesCorrect = (_pageIndexes.length == pages);
    bool panelsCorrect = (_panelIndexes.length == panels);
    bool partsCorrect = (_partIndexes.length == parts);

    bool allCorrect = pagesCorrect && panelsCorrect && partsCorrect;

    if (!allCorrect){
      final String pageMsg="expected $pages pages, but got ${_pageIndexes.length}\n";
      final String panelMsg="expected $panels panels, but got ${_panelIndexes.length}\n";
      final String partMsg="expected $parts parts, but got ${_partIndexes.length}\n";
      final msg=pageMsg+panelMsg+partMsg;
      print(msg);
      throw TestException(msg);
    }
  }
}

class KitchenSinkTest {
  PScript init({PScript script,bool useCaptionsAsIds = true}) {
    preceptDefaultInjectionBindings();
    pageLibrary.init();
    panelLibrary.init();
    partLibrary.init();
    backendLibrary.init();
    script.validate(useCaptionsAsIds: useCaptionsAsIds);
    if (script.failed) {
      script.validationOutput();
      throw TestException("Validation failure");
    }
    return script;
  }
}
