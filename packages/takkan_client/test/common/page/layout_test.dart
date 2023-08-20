import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/pod/layout/layout.dart';

import '../../helper/mock.dart';

void main() {
  group('DisplayColumns mixin', () {
    late DisplayColumnsTest dct;

    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      dct = DisplayColumnsTest();
    });

    tearDown(() {});

    test("Screen size exactly one column wide", () {
      // given
      final widgets = [MockPanel(), MockPanel()];
      // when
      final dim =
          dct.dimensions(screenSize: Size(360, 700), preferredColumnWidth: 360);
      final rowOfColumns = dct.distributeWidgets(
          screenSize: Size(360, 700),
          preferredColumnWidth: 360,
          widgets: widgets);
      // then
      expect(dim.numberOfColumns, 1);
      expect(dim.columnWidth, 360);
      expect(rowOfColumns.children.length, 1,
          reason: "number of columns, each will be a ListView in a Container");
      expect(((rowOfColumns.children[0]) as Container).child, isA<ListView>());
      final ListView? view =
          ((rowOfColumns.children[0]) as Container).child as ListView;
      expect(
          (view?.childrenDelegate as SliverChildListDelegate).children.length,
          2,
          reason: "All widgets in one column");
      expect(dim.screenLessThanPreferredWidth, isFalse);
    });

    test("Screen size supports two columns exactly", () {
      // given
      final widgets = [
        MockPanel(),
        MockPanel(),
        MockPanel(),
        MockPanel(),
        MockPanel()
      ];
      // when
      final dim =
          dct.dimensions(screenSize: Size(720, 700), preferredColumnWidth: 360);
      final rowOfColumns = dct.distributeWidgets(
          screenSize: Size(720, 700),
          preferredColumnWidth: 360,
          widgets: widgets);
      // then
      expect(dim.numberOfColumns, 2);
      expect(dim.columnWidth, 360);
      expect(rowOfColumns.children.length, 2,
          reason: "number of columns, each will be a ListView in a Container");
      expect(((rowOfColumns.children[0]) as Container).child, isA<ListView>());
      final ListView? view1 =
          ((rowOfColumns.children[0]) as Container).child as ListView;
      final ListView? view2 =
          ((rowOfColumns.children[1]) as Container).child as ListView;
      expect(
          (view1?.childrenDelegate as SliverChildListDelegate).children.length,
          3,
          reason: "3 widgets in first column");
      expect(
          (view2?.childrenDelegate as SliverChildListDelegate).children.length,
          2,
          reason: "2 widgets in second column");
      expect(dim.screenLessThanPreferredWidth, isFalse);
    });

    test(
        "Screen size supports two columns, but widens columns to fit all available space",
        () {
      // given
      final widgets = [
        MockPanel(),
        MockPanel(),
        MockPanel(),
        MockPanel(),
        MockPanel()
      ];
      // when
      final dim =
          dct.dimensions(screenSize: Size(760, 700), preferredColumnWidth: 360);
      final rowOfColumns = dct.distributeWidgets(
          screenSize: Size(760, 700),
          preferredColumnWidth: 360,
          widgets: widgets);
      // then
      expect(dim.numberOfColumns, 2);
      expect(dim.columnWidth, 380);
      expect(rowOfColumns.children.length, 2,
          reason: "number of columns, each will be a ListView in a Container");
      expect(((rowOfColumns.children[0]) as Container).child, isA<ListView>());
      final ListView? view1 =
          ((rowOfColumns.children[0]) as Container).child as ListView;
      final ListView? view2 =
          ((rowOfColumns.children[1]) as Container).child as ListView;
      expect(
          (view1?.childrenDelegate as SliverChildListDelegate).children.length,
          3,
          reason: "3 widgets in first column");
      expect(
          (view2?.childrenDelegate as SliverChildListDelegate).children.length,
          2,
          reason: "2 widgets in second column");
      expect(dim.screenLessThanPreferredWidth, isFalse);
    });

    test(
        "Screen size will not support even a single column, column width reduces",
        () {
      // given
      final widgets = [MockPanel(), MockPanel()];
      // when
      final dim =
          dct.dimensions(screenSize: Size(320, 700), preferredColumnWidth: 360);
      final rowOfColumns = dct.distributeWidgets(
          screenSize: Size(320, 700),
          preferredColumnWidth: 360,
          widgets: widgets);
      // then
      expect(dim.numberOfColumns, 1);
      expect(dim.columnWidth, 320);
      expect(rowOfColumns.children.length, 1,
          reason: "number of columns, each will be a ListView in a Container");
      expect(((rowOfColumns.children[0]) as Container).child, isA<ListView>());
      final ListView? view =
          ((rowOfColumns.children[0]) as Container).child as ListView;
      expect(
          (view?.childrenDelegate as SliverChildListDelegate).children.length,
          2,
          reason: "All widgets in one column");
      expect(dim.screenLessThanPreferredWidth, isTrue);
    });
  });
}

class DisplayColumnsTest with DisplayColumns {}
