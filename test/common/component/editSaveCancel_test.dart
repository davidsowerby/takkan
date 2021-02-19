import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/common/component/editSaveCancel.dart';
import 'package:precept_client/data/dataSource.dart';

import '../../helper/mock.dart';

void main() {
  group('EditSaveCancel', () {
    DataSource dataSource;
    BuildContext context;
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      dataSource = MockDataSource();
      context = MockBuildContext();
    });

    tearDown(() {});

    test('output', () {
      // given
      final esc = EditSaveCancel();
      // when
      esc.build(context);
      // then

      expect(1, 0);
    });
  });
}
