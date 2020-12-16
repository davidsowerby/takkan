import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/app/page/standardPage.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_client/precept/library/panelLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/panel/panel.dart';
import 'package:precept_client/precept/part/part.dart';
import 'package:precept_script/common/logger.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

import '../../helper/exception.dart';

/// See [developer guide](https://www.preceptblog.co.uk/developer-guide/kitchensink.html#static-page)
///

final PScript kitchenSink00 = PScript(isStatic: IsStatic.yes, components: [
  PComponent(
    name: 'core',
    routes: [
      PRoute(
        path: '/test',
        page: PPage(
          pageType: Library.simpleKey,
          title: 'Kitchen Sink 00',
          content: [
            PString(id: 'Part 1', staticData: 'Part 1'),
            PPanel(
              id: 'Panel 2',
              heading: PPanelHeading(title: 'Panel 2'),
              content: [
                PPanel(
                  id: 'Panel 2-1',
                  heading: PPanelHeading(title: 'Panel 2-1'),
                  content: [
                    PString(id: 'Part 2-1-1', staticData: 'Part 2-1-1'),
                    PString(id: 'Part 2-1-2', staticData: 'Part 2-1-2'),
                  ],
                ),
                PString(id: 'Part 2-2', staticData: 'Part 2-2'),
                PString(id: 'Part 2-3', staticData: 'Part 2-3'),
              ],
            ),
            PString(id: 'Part 3', staticData: 'Part 3'),
          ],
        ),
      ),
    ],
  ),
]);

void main() {
  group('Static Page (kitchen-sink-00)', () {
     WidgetTestTree testTree;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {
      testTree.debug.forEach((element) {
        print("$element\n");});
    });

    testWidgets('All ', (WidgetTester tester) async {
      // given
      preceptDefaultInjectionBindings();
      pageLibrary.init();
      panelLibrary.init();
      partLibrary.init();
      final script = kitchenSink00;
      script.init();
      // when
      final widgetTree = MaterialApp(
          home: PageBuilder().build(
        config: script.components[0].routes[0].page,
      ));
      await tester.pumpWidget(widgetTree);
      testTree = WidgetTestTree(tester.allWidgets.toList());
      // then
      expect(testTree.pageIndex, 84);
      expect(testTree.pageHasDataSource, isFalse);
      expect(testTree.pageHasDataBinding, isFalse);
      expect(testTree.pageHasEditState, isFalse);
      expect(testTree.elementHasPanelState('Panel 2'), isTrue);
      expect(testTree.elementHasPanelState('Panel 2-1'), isTrue);

      expect(testTree.elementHasEditState('Panel 2'), isFalse);
      expect(testTree.elementHasDataBinding('Panel 2'), isFalse);
      expect(testTree.elementHasDataSource('Panel 2'), isFalse);

      expect(testTree.elementHasEditState('Panel 2-1'), isFalse);
      expect(testTree.elementHasDataBinding('Panel 2-1'), isFalse);
      expect(testTree.elementHasDataSource('Panel 2-1'), isFalse);

      expect(testTree.elementHasEditState('Part 1'), isFalse);
      expect(testTree.elementHasDataBinding('Part 1'), isFalse);
      expect(testTree.elementHasDataSource('Part 1'), isFalse);

      expect(testTree.elementHasEditState('Part 3'), isFalse);
      expect(testTree.elementHasDataBinding('Part 3'), isFalse);
      expect(testTree.elementHasDataSource('Part 3'), isFalse);

      expect(testTree.elementHasEditState('Part 2-2'), isFalse);
      expect(testTree.elementHasDataBinding('Part 2-2'), isFalse);
      expect(testTree.elementHasDataSource('Part 2-2'), isFalse);


      expect(testTree.elementHasEditState('Part 2-3'), isFalse);
      expect(testTree.elementHasDataBinding('Part 2-1-1'), isFalse);
      expect(testTree.elementHasDataSource('Part 2-1-2'), isFalse);
    });
  });
}

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
