import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('Page', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('autoRoute', () {
      // given
      final Script s = Script(
        name: 'test',
        version: const Version(number: 0),
        schema: Schema(
          version: const Version(number: 0),
          name: 'test',
        ),
        pages: [
          Page(
            name: 'profile',
            documentClass: 'Person',
            dataSelectors: [
              const DataItemById(
                name: 'MyObject',
                objectId: 'xxx',
              ),
              const DataItem(name: 'mine', caption: '?'),
            ],
          ),
          Page(
            name: 'shortForm',
            documentClass: 'Person',
            dataSelectors: [
              const DataItemById(
                name: 'MyObject',
                objectId: 'xxx',
              ),
              const DataItem(name: 'person'),
            ],
          ),
          Page(
            name: 'crowd',
            documentClass: 'Person',
            dataSelectors: [
              const DataList(name: 'people'),
            ],
          ),
          Page(
            name: 'people',
            documentClass: 'Person',
            dataSelectors: [
              const DataListByFilter(
                name: 'members',
                script: 'member==true',
              )
            ],
          ),
          Page(
            name: 'home',
          )
        ],
      );

      // when
      s.init();
      // then

      expect(s.routeMap.length, 7);
      for (final route in s.routeMap.keys) {
        print(route.toString());
      }

      expect(
          s.routeMap.containsKey(TakkanRoute.fromString('home/static')), isTrue);
      expect(
          s.routeMap
              .containsKey(TakkanRoute.fromString('profile/MyObject/xxx')),
          isTrue);
      expect(s.routeMap.containsKey(TakkanRoute.fromString('profile/mine')),
          isTrue);
      expect(s.routeMap.containsKey(TakkanRoute.fromString('shortForm/person')),
          isTrue);
      expect(s.routeMap.containsKey(TakkanRoute.fromString('crowd/people')),
          isTrue);
      expect(
          s.routeMap
              .containsKey(TakkanRoute.fromString('shortForm/MyObject/xxx')),
          isTrue);

      expect(s.routeMap.containsKey(TakkanRoute.fromString('people/members')),
          isTrue);

      expect(s.pages[0].isStatic, isFalse);
      expect(s.pages[4].isStatic, isTrue);

      Data dataSelector=s.pages[0].dataSelectorByName('MyObject');
      expect(dataSelector, isA<DataItemById>());
      expect((dataSelector as DataItemById).objectId,'xxx');

      dataSelector=s.pages[0].dataSelectorByName('WhatNoPage');
      expect(dataSelector, isA<NoData>());
    });
  });
}
