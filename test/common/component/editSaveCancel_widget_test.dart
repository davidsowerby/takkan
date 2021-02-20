import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:precept_client/common/component/editSaveCancel.dart';
import 'package:precept_client/common/component/keyAssist.dart';
import 'package:precept_client/page/editState.dart';
import 'package:provider/provider.dart';

import '../../helper/mock.dart';
import '../../helper/widgetTestTree.dart';
import '../../testAssist.dart';

void main() {
  group('Static Page (kitchen-sink-00)', () {
    WidgetTestTree testTree;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    testWidgets('All ', (WidgetTester tester) async {
      // given
      MockDataSource dataSource = MockDataSource();
      final escKey = 'esc';
      final esc = EditSaveCancel(
        key: keys(null,[escKey]),
        dataSource: dataSource,
      );
      final EditState editState = EditState(readMode: true);
      // when
      final widgetTree = MaterialApp(
          home: Card(
        child: ChangeNotifierProvider<EditState>(
          create: (_) => editState,
          child: esc,
        ),
      ));
      await tester.pumpWidget(widgetTree);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // then we are in read mode
      row(esc.rowKey).contains([esc.blankKey,esc.editKey]);

      // when
      await tester.tap(find.byKey(esc.editKey));
      await tester.pumpWidget(widgetTree);

      // then
      row(esc.rowKey).contains([esc.saveKey,esc.cancelKey]);

      // when we cancel
      await tester.tap(find.byKey(esc.cancelKey));
      await tester.pumpWidget(widgetTree);

      // then we are in read mode
      verify(dataSource.reset());
      row(esc.rowKey).contains([esc.blankKey,esc.editKey]);

      // go back into edit mode
      await tester.tap(find.byKey(esc.editKey));
      await tester.pumpWidget(widgetTree);

      // when we save, with invalid data
      when(dataSource.validate()).thenReturn(false);
      await tester.tap(find.byKey(esc.saveKey));
      await tester.pumpWidget(widgetTree);

      // then stay in edit mode
      row(esc.rowKey).contains([esc.saveKey,esc.cancelKey]);

      // when we save, with valid data
      when(dataSource.validate()).thenReturn(true);
      await tester.tap(find.byKey(esc.saveKey));
      await tester.pumpWidget(widgetTree);

      // then we are back in read mode
      row(esc.rowKey).contains([esc.blankKey,esc.editKey]);
      verifyInOrder([dataSource.validate(), dataSource.flushFormsToModel(), dataSource.persist()]);

    });
  });
}





