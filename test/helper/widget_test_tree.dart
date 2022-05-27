import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/inject/modules.dart';
import 'package:takkan_client/library/library.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:takkan_client/pod/page/standard_page.dart';
import 'package:takkan_client/pod/panel/panel.dart';
import 'package:takkan_client/part/part.dart';
import 'package:provider/provider.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/data_provider_library.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/script/script.dart';

import './exception.dart';
import 'mock.dart';

/// [pages], [panels] & [parts] are the number of each expected to be found.  This is checked by calling [verify]
class WidgetTestTree {
  final List<Widget> widgets;
  final List<String?> elementDebugs = List.empty(growable: true);
  final int pages;
  final int panels;
  final int parts;
  final Script script;

  WidgetTestTree(this.script, this.widgets,
      {this.pages = 1, this.panels = 2, this.parts = 6}) {
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
      if (widget is TakkanPage) {
        _pageIndexes[widget.config.debugId] = index;
        _allIndexes[widget.config.debugId] = index;
        elementDebugs.add(widget.config.debugId);
      } else if (widget is PanelWidget) {
        _panelIndexes[widget.config.debugId] = index;
        _allIndexes[widget.config.debugId] = index;
        elementDebugs.add(widget.config.debugId);
      } else if (widget is ParticleSwitch) {
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
      if (widgets[index] is TakkanPage) break;
      if (widgets[index] is PanelWidget) break;
      if (widgets[index] is ParticleSwitch) break;
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
    // final index = _allIndexes[id]!;
    // final Widget widget = widgets[index];
    // final PodState state = tester.state(find.byWidget(widget)) as PodState;
    // return state.hasModelBinding;
    throw UnsupportedError('rethink');
  }

  bool elementHasDataStore(String id, Type type, WidgetTester tester) {
    // final index = _allIndexes[id]!;
    // final Widget widget = widgets[index];
    // final PodState state = tester.state(find.byWidget(widget)) as PodState;
    // return state.dataContext.isRoot;
    throw UnsupportedError('rethink');
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
  Script init(
      {required Script script,
      bool useCaptionsAsIds = true,
      required AppConfig appConfig}) {
    takkanDefaultInjectionBindings();
    library.init();
    dataProviderLibrary.register(
        type: 'mock', builder: (dp) => MockDataProvider());
    dataProviderLibrary.init(appConfig);
    script.validate(useCaptionsAsIds: useCaptionsAsIds);
    if (script.failed) {
      script.validationOutput();
      throw TestException("Validation failure");
    }
    return script;
  }
}
