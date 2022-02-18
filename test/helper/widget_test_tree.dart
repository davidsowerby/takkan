import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_client/common/content/content_state.dart';
import 'package:precept_client/data/data_binding.dart';
import 'package:precept_client/inject/modules.dart';
import 'package:precept_client/library/part_library.dart';
import 'package:precept_client/page/edit_state.dart';
import 'package:precept_client/page/standard_page.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

import './exception.dart';
import 'fake.dart';

/// [pages], [panels] & [parts] are the number of each expected to be found.  This is checked by calling [verify]
class WidgetTestTree {
  final List<Widget> widgets;
  final List<String?> elementDebugs = List.empty(growable: true);
  final int pages;
  final int panels;
  final int parts;
  final PScript script;

  WidgetTestTree(this.script, this.widgets, {this.pages = 1, this.panels = 2, this.parts = 6}) {
    _scan();
  }

  Map<String?, int> _panelIndexes = Map();
  Map<String?, int> _partIndexes = Map();
  Map<String?, int> _pageIndexes = Map();
  Map<String?, int> _allIndexes = Map();

  final List<String> debug = List.empty(growable: true);

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

  Widget panelWidget({panelIndex=0}){
    final key=_panelIndexes.keys.toList()[panelIndex];
    final widgetIndex=_panelIndexes[key];
    return widgets[widgetIndex!];
  }

  int _upFromElement(String id, bool Function(Widget) typeTest) {
    int index = _allIndexes[id]! - 1;
    while (index >= 0) {
      if (typeTest(widgets[index])) {
        return index;
      }
      // TODO: this is a bit fragile, would need new types adding
      if (widgets[index] is PreceptPage) break;
      if (widgets[index] is Panel) break;
      if (widgets[index] is Part) break;
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
    int result = _upFromElement(id, typeTest);
    bool found = result >= 0;
    String text = (found) ? "found at $result" : 'NOT found';
    debug.add("Looking for ${lookingFor.toString()} in $id:  $text");
    return found;
  }

  bool elementHasEditState(String id) {
    return elementHas(id, (widget) => widget is ChangeNotifierProvider<EditState>, EditState);
  }

  bool elementHasDataBinding(String id, Type type, WidgetTester tester) {
    final index = _allIndexes[id]!;
    final Widget widget = widgets[index];
    final ContentState state = tester.state(find.byWidget(widget)) as ContentState;
    return (state.dataBinding is FullDataBinding);
  }

  bool elementHasDataSource(String id, Type type, WidgetTester tester) {
    final index = _allIndexes[id]!;
    final Widget widget = widgets[index];
    final ContentState state = tester.state(find.byWidget(widget)) as ContentState;
    return state.dataSource != null;
  }

  verify() {
    bool pagesCorrect = (_pageIndexes.length == pages);
    bool panelsCorrect = (_panelIndexes.length == panels);
    bool partsCorrect = (_partIndexes.length == parts);

    bool allCorrect = pagesCorrect && panelsCorrect && partsCorrect;

    if (!allCorrect) {
      final String pageMsg = "expected $pages pages, but got ${_pageIndexes.length}\n";
      final String panelMsg = "expected $panels panels, but got ${_panelIndexes.length}\n";
      final String partMsg = "expected $parts parts, but got ${_partIndexes.length}\n";
      final msg = pageMsg + panelMsg + partMsg;
      print(msg);
      throw TestException(msg);
    }
  }
}

class KitchenSinkTest {
  PScript init(
      {required PScript script, bool useCaptionsAsIds = true, required AppConfig appConfig}) {
    preceptDefaultInjectionBindings();
    partLibrary.init();
    PFakeDataProvider.register();
    dataProviderLibrary.init(appConfig);
    script.validate(useCaptionsAsIds: useCaptionsAsIds);
    if (script.failed) {
      script.validationOutput();
      throw TestException("Validation failure");
    }
    return script;
  }
}
