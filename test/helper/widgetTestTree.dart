import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/app/page/standardPage.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/panel/panel.dart';
import 'package:precept_client/precept/part/part.dart';
import 'package:precept_script/common/logger.dart';
import 'package:provider/provider.dart';

import './exception.dart';

class WidgetTestTree {
  final List<Widget> widgets;

  WidgetTestTree(this.widgets) {
    _scan();
  }

  Map<String, int> _panelIndexes = Map();
  Map<String, int> _partIndexes = Map();

  int _pageIndex;

  final List<String> debug=List();

  _scan() {
    int index = 0;
    for (Widget widget in widgets) {
      if (widget is PreceptPage) {
        _pageIndex = index;
      } else if (widget is Panel) {
        _panelIndexes[widget.config.id] = index;
      } else if (widget is Part) {
        _partIndexes[widget.config.id] = index;
      }
      index++;
    }
  }

  int get pageIndex => _pageIndex;

  bool get pageHasDataSource =>
      _pageHas((widget) => widget is ChangeNotifierProvider<DataSource>);

  bool get pageHasDataBinding =>
      _pageHas((widget) => widget is ChangeNotifierProvider<DataBinding>);

  bool get pageHasEditState =>
      _pageHas((widget) => widget is ChangeNotifierProvider<EditState>);

  bool _pageHas(bool Function(Widget) typeTest) {
    return _upFromElement(pageIndex, typeTest) > -1;
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
    final indexMap = (id.startsWith('Part')) ? _partIndexes : _panelIndexes;
    final index = indexMap[id];
    if (index==null){
      String msg = "${this.runtimeType.toString()} cannot find '$id'. The _scan did not find it";
      logType(this.runtimeType).e("");
      debug.add(msg);
      throw TestException(msg);
    }
    int result = _upFromElement(index, typeTest);
    bool found = result >= 0;
    String text=(found) ? "found at $result" : 'NOT found';
    debug.add("Looking for ${lookingFor.toString()} in $id:  $text");
    return found;
  }

  bool elementHasEditState(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<EditState>, EditState);
  }

  bool  elementHasPanelState(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<PanelState>, PanelState);
  }

  bool  elementHasDataBinding(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<DataBinding>,DataBinding);
  }

  bool  elementHasDataSource(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<DataSource>, DataSource);
  }
}