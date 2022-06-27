import 'package:takkan_medley_script/medley/medley_script.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';

import 'package:test/test.dart';

void main() {
  group('TakkanRoute', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('construct from config, item selectors', () {
      // given
      final Page page = Page(
        name: 'person',
        documentClass: 'Person',
        dataSelectors: [
          const DataItem(name: 'person'),
          const DataItem(name: 'tagged'),
          const DataItemById(name: 'byId', objectId: 'xxx'),
          const DataItemByFilter(script: 'age>=18', name: 'adult'),
          const DataItemByFunction(cloudFunctionName: 'mostRecent'),
          const DataItemByGQL(script: 'gqlScript', name: 'allWithRelatives'),
        ],
      );
      // when
      final actual0 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[0]);
      final actual1 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[1]);
      final actual2 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[2]);
      final actual3 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[3]);
      final actual4 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[4]);
      final actual5 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[5]);
      // then
      const String string0 = 'person/person';
      expect(actual0.toString(), string0);
      expect(TakkanRoute.fromString(string0), actual0);

      const String string1 = 'person/tagged';
      expect(actual1.toString(), string1);
      expect(TakkanRoute.fromString(string1), actual1);

      const String string2 = 'person/byId';
      expect(actual2.toString(), string2);
      expect(TakkanRoute.fromString(string2), actual2);

      const String string3 = 'person/adult';
      expect(actual3.toString(), string3);
      expect(TakkanRoute.fromString(string3), actual3);

      const String string4 = 'person/mostRecent';
      expect(actual4.toString(), string4);
      expect(TakkanRoute.fromString(string4), actual4);

      const String string5 = 'person/allWithRelatives';
      expect(actual5.toString(), string5);
      expect(TakkanRoute.fromString(string5), actual5);
    });

    test('construct from config, list selectors', () {
      // given
      final Page page = Page(
        name: 'person',
        documentClass: 'Person',
        dataSelectors: [
          const DataList(name: 'people'),
          const DataList(name: 'tagged'),
          const DataListById(name: 'byId', objectIds: ['xxx', 'yyy']),
          const DataListByFilter(script: 'age>=18', name: 'adult'),
          const DataListByFunction(cloudFunctionName: 'mostRecent'),
          const DataListByGQL(script: 'gqlScript', name: 'allWithRelatives'),
        ],
      );
      // when
      final actual0 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[0]);
      final actual1 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[1]);
      final actual2 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[2]);
      final actual3 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[3]);
      final actual4 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[4]);
      final actual5 =
          TakkanRoute.fromConfig(page: page, selector: page.dataSelectors[5]);
      // then
      const String string0 = 'person/people';
      expect(actual0.toString(), string0);
      expect(TakkanRoute.fromString(string0), actual0);

      const String string1 = 'person/tagged';
      expect(actual1.toString(), string1);
      expect(TakkanRoute.fromString(string1), actual1);

      const String string2 = 'person/byId';
      expect(actual2.toString(), string2);
      expect(TakkanRoute.fromString(string2), actual2);

      const String string3 = 'person/adult';
      expect(actual3.toString(), string3);
      expect(TakkanRoute.fromString(string3), actual3);

      const String string4 = 'person/mostRecent';
      expect(actual4.toString(), string4);
      expect(TakkanRoute.fromString(string4), actual4);

      const String string5 = 'person/allWithRelatives';
      expect(actual5.toString(), string5);
      expect(TakkanRoute.fromString(string5), actual5);
    });

    test('construct from config, static page', () {
      // given
      final Script script = Script(
          version: const Version(number: 0),
          name: 'test',
          pages: [
            Page(name: 'static-page'),
          ],
          schema: Schema(version: const Version(number: 0), name: 'test'));
      script.init();
      final page = script.pages[0];
      // when
      final actual0 =
          TakkanRoute.fromConfig(page: page, selector: const NoData());
      // then
      const String string0 = 'static-page/static';
      expect(actual0.toString(), string0);
      expect(TakkanRoute.fromString(string0).toString(), actual0.toString());
      expect(TakkanRoute.fromString(string0) == actual0, isTrue);
    });

    test('document with page tag and objectId', () {
      // given
      const String stringRoute = 'person/all';
      // when
      final TakkanRoute route = TakkanRoute.fromString(stringRoute);
      // then
      expect(route.toString(), stringRoute);
      expect(route.dataSelectorName, 'all');
      expect(route.pageName, 'person');
    });

    test('compare instances', () {
      // given
      const route1 = TakkanRoute(dataSelectorName: 'home', pageName: 'static');
      const route2 = TakkanRoute(dataSelectorName: 'home', pageName: 'statics');
      const route3 = TakkanRoute(dataSelectorName: 'home1', pageName: 'static');
      // when

      // then

      expect(route1, route1, reason: 'identical params');

      expect(route1 == route1, isTrue,
          reason: 'identical params, different compare');

      // expect(route1.hashCode==route2.hashCode,isFalse);
      // expect(route1==route2,isFalse);
      expect(route1==route3,isFalse);

    });

    /// What needs testing here?
    test('medley script2', () {
      // given
      final script = medleyScript2;
      script.init();
      // when

      // then

      expect(1, 0);
    }, skip: true);
  });
}
