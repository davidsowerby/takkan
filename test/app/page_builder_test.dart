import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/pod/page/document_list_page.dart';
import 'package:takkan_client/pod/page/document_page.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

import '../helper/mock.dart';

void main() {
  DocumentCache cache = MockDocumentCache();
  late PageBuilder builder;
  late Script script;
  registerFallbackValue(NullDataContext());
  registerFallbackValue(DataItemById(name: 'itemWithId', objectId: 'x'));
  registerFallbackValue(DataItem(name: 'item'));
  group('PageBuilder', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      script = Script(
        name: 'test',
        version: Version(number: 0),
        schema: Schema(
          version: Version(number: 0),
          name: 'test',
          documents: {'Person': Document(fields: {})},
        ),
        pages: [
          PageConfig.Page(
            name: 'person',
            documentClass: 'Person',
            dataSelectors: [
              DataItemById(
                name: 'MyObject',
                objectId: 'xxx',
              ),
              DataItem(name: 'anyObject'),
            ],
          ),
          PageConfig.Page(
            documentClass: 'Person',
            name: 'shortForm',
            dataSelectors: [
              DataItemById(
                name: 'MyObject',
                objectId: 'xxx',
              ),
              DataItem(name: 'anyObject'),
            ],
          ),
          PageConfig.Page(
            name: 'people',
            documentClass: 'Person',
            dataSelectors: [
              DataList(name: 'allPeople'),
            ],
          ),
          PageConfig.Page(
            name: 'member',
            documentClass: 'Person',
            dataSelectors: [
              DataListByFilter(
                name: 'members',
                script: 'member==true',
              )
            ],
          ),
          PageConfig.Page(
            name: 'emptyStatic',
          ),
          PageConfig.Page(
            name: 'members',
            documentClass: 'Person',
            dataSelectors: [
              DataListById(
                name: 'specialMembers',
                objectIds: ['xxx', 'yyy'],
              )
            ],
          ),
        ],
      );
      script.init();
      builder = DefaultPageBuilder();
    });

    tearDown(() {});

    test('single page, DataItemById', () {
      // given
      final pageConfig = script.pages[0];
      const String route='person/MyObject';
      when(()=> cache.getClassCache(config: pageConfig)).thenReturn(MockDocumentClassCache());
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItemById>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: route,
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId,
          (pageConfig.dataSelectors[0] as DataItemById).objectId);
      expect(page.route.toString(), route);
    });
    test('single page, DataItem second selector', () {
      // given
      final pageConfig = script.pages[0];
      const String route='person/anyObject';
      when(()=> cache.getClassCache(config: pageConfig)).thenReturn(MockDocumentClassCache());
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: route,
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId, isNull);
      expect(page.route.toString(), route);
    });
    test('single page, DataItemById,  Page', () {
      // given
      final pageConfig = script.pages[1];
      const String route='shortForm/MyObject';
      when(()=> cache.getClassCache(config: pageConfig)).thenReturn(MockDocumentClassCache());
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItemById>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: route,
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId,
          (pageConfig.dataSelectors[0] as DataItemById).objectId);
      expect(page.route.toString(), route);
    });
    test('single page,  DataItem , Page', () {
      // given
      final pageConfig = script.pages[1];
      const String route='shortForm/anyObject';
      when(()=> cache.getClassCache(config: pageConfig)).thenReturn(MockDocumentClassCache());
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: route,
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId, isNull);
      expect(page.route.toString(), route);
    });
    test('multi page,  PMulti', () {
      // given
      final pageConfig = script.pages[2];
      const String route='people/allPeople';
      when(()=> cache.getClassCache(config: pageConfig)).thenReturn(MockDocumentClassCache());
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: route,
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentListPage>());
      final DocumentListPage page = p as DocumentListPage;
      expect(page.config, pageConfig);
      expect(page.route.toString(),route);
    });
    test('multi page,  PMulti', () {
      // given
      final pageConfig = script.pages[3];
      const String route='member/members';
      when(()=> cache.getClassCache(config: pageConfig)).thenReturn(MockDocumentClassCache());
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: route,
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentListPage>());
      final DocumentListPage page = p as DocumentListPage;
      expect(page.config, pageConfig);
      expect(page.route.toString(), route);
      expect(page.objectIds, isNull);
    });
  });
}
