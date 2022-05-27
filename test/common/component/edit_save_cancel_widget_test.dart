import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takkan_client/common/component/edit_save_cancel.dart';
import 'package:takkan_client/common/component/key_assist.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:provider/provider.dart';

import '../../helper/mock.dart';
import '../../test_assist.dart';

void main() {
  group('Static Page (kitchen-sink-00)', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    testWidgets('All ', (WidgetTester tester) async {
      // given
      MockDocumentRoot dataStore = MockDocumentRoot();
      final escKey = 'esc';
      final esc = EditSaveCancel(
        key: keys(null, [escKey]),
        // documentRoot: dataStore,
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
      row(esc.rowKey).contains([esc.blankKey, esc.editKey]);

      // when
      await tester.tap(find.byKey(esc.editKey));
      await tester.pumpWidget(widgetTree);

      // then
      row(esc.rowKey).contains([esc.saveKey, esc.cancelKey]);

      // when we cancel
      await tester.tap(find.byKey(esc.cancelKey));
      await tester.pumpWidget(widgetTree);

      // then we are in read mode
      verify(() => dataStore.cancelChanges());
      row(esc.rowKey).contains([esc.blankKey, esc.editKey]);

      // go back into edit mode
      await tester.tap(find.byKey(esc.editKey));
      await tester.pumpWidget(widgetTree);

      // when we save, with invalid data
      when(() => dataStore.validate()).thenReturn(false);
      await tester.tap(find.byKey(esc.saveKey));
      await tester.pumpWidget(widgetTree);

      // then stay in edit mode
      row(esc.rowKey).contains([esc.saveKey, esc.cancelKey]);

      // when we save, with valid data
      when(() => dataStore.validate()).thenReturn(true);
      // when(() => dataStore.save()).thenAnswer((_) async => UpdateResult(
      //     success: true, documentClass: 'Wiggly', objectId: 'beast', data: {}));
      when(() => dataStore.save()).thenAnswer((_) async => true);
      await tester.tap(find.byKey(esc.saveKey));
      await tester.pumpWidget(widgetTree);

      // then we are back in read mode
      // row(esc.rowKey).contains([esc.blankKey, esc.editKey]);
      verifyInOrder([
        () => dataStore.validate(),
        () => dataStore.flushFormsToModel(),
        () => dataStore.save(),
      ]);
    },skip: true);
  });
}
