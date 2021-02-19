import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:precept_client/common/component/editSaveCancel.dart';
import 'package:precept_client/page/editState.dart';
import 'package:provider/provider.dart';

import '../../helper/mock.dart';
import '../../helper/widgetTestTree.dart';

void main() {
  group('Static Page (kitchen-sink-00)', () {
    WidgetTestTree testTree;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {

    });

    testWidgets('All ', (WidgetTester tester) async {
      // given
      MockDataSource dataSource=MockDataSource();
      final escKey = Key('esc');
      final rowKey = Key('$escKey:row');
      final saveKey = Key('$escKey:row:saveButton');
      final editKey = Key('$escKey:row:editButton');
      final cancelKey = Key('$escKey:row:cancelButton');
      final blankKey = Key('$escKey:row:blankButton');
      final esc = EditSaveCancel(key: escKey, dataSource: dataSource,);
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
      expect(find.byKey(escKey), findsOneWidget);
      expect(find.byKey(rowKey), findsOneWidget);
      expect(find.byKey(blankKey), findsOneWidget);
      expect(find.byKey(editKey), findsOneWidget);

      // when
      await tester.tap(find.byKey(editKey));
      await tester.pumpWidget(widgetTree);

      // then
      expect(find.byKey(escKey), findsOneWidget);
      expect(find.byKey(rowKey), findsOneWidget);
      expect(find.byKey(saveKey), findsOneWidget);
      expect(find.byKey(cancelKey), findsOneWidget);

      // when we cancel
      await tester.tap(find.byKey(cancelKey));
      await tester.pumpWidget(widgetTree);

      // then we are in read mode
      verify(dataSource.reset());
      expect(find.byKey(escKey), findsOneWidget);
      expect(find.byKey(rowKey), findsOneWidget);
      expect(find.byKey(blankKey), findsOneWidget);
      expect(find.byKey(editKey), findsOneWidget);

      // go back into edit mode
      await tester.tap(find.byKey(editKey));
      await tester.pumpWidget(widgetTree);

      // when we save, with invalid data
      when(dataSource.validate()).thenReturn(false);
      await tester.tap(find.byKey(saveKey));
      await tester.pumpWidget(widgetTree);

      // then stay in edit mode
      expect(find.byKey(escKey), findsOneWidget);
      expect(find.byKey(rowKey), findsOneWidget);
      expect(find.byKey(saveKey), findsOneWidget);
      expect(find.byKey(cancelKey), findsOneWidget);

      // when we save, with valid data
      when(dataSource.validate()).thenReturn(true);
      await tester.tap(find.byKey(saveKey));
      await tester.pumpWidget(widgetTree);

      // then we are back in read mode
      verifyInOrder([dataSource.validate(), dataSource.flushFormsToModel(),dataSource.persist()]);
      expect(find.byKey(escKey), findsOneWidget);
      expect(find.byKey(rowKey), findsOneWidget);
      expect(find.byKey(blankKey), findsOneWidget);
      expect(find.byKey(editKey), findsOneWidget);
    });
  });
}
