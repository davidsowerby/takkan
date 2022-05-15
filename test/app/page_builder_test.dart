import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:precept_client/app/page_builder.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/data/document_cache.dart';
import 'package:precept_client/library/part_library.dart';
import 'package:precept_client/page/document_list_page.dart';
import 'package:precept_client/page/document_page.dart';
import 'package:precept_client/page/static_page.dart';
import 'package:precept_script/data/select/data_item.dart';
import 'package:precept_script/data/select/data_list.dart';
import 'package:precept_script/page/page.dart' as PageConfig;
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

import '../helper/mock.dart';

void main() {
  PartLibrary partLibrary = MockPartLibrary();
  DocumentCache cache = MockDocumentCache();
  late PageBuilder builder;
  late Script script;
  registerFallbackValue(NullDataContext());
  registerFallbackValue(DataItemById(objectId: 'x'));
  registerFallbackValue(DataItem());
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
            documentClass: 'Person',
            dataSelectors: [
              DataItemById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              DataItem(),
            ],
          ),
          PageConfig.Page(
            documentClass: 'Person',
            tag: 'shortForm',
            dataSelectors: [
              DataItemById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              DataItem(),
            ],
          ),
          PageConfig.Page(
            documentClass: 'Person',
            dataSelectors: [
              DataList(),
            ],
          ),
          PageConfig.Page(
            documentClass: 'Person',
            dataSelectors: [
              DataListByFilter(
                tag: 'members',
                script: 'member==true',
              )
            ],
          ),
          PageStatic(
            routes: ['static page'],
          ),
          PageConfig.Page(
            documentClass: 'Person',
            dataSelectors: [
              DataListById(
                tag: 'specialMembers',
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

    test('static page', () {
      // given
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: 'static page',
        pageArguments: const {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        partLibrary: partLibrary,
        script: script,
        cache: cache,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<StaticPage>());
      final StaticPage page = p as StaticPage;
      expect(page.route, 'static page');
    });
    test('single page, tagged DataItemById', () {
      // given
      final pageConfig = script.pages[0] as PageConfig.Page;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItemById>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: 'document/Person/MyObject',
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
        partLibrary: partLibrary,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId,
          (pageConfig.dataSelectors[0] as DataItemById).objectId);
      expect(page.route, 'document/Person/MyObject');
    });
    test('single page, untagged DataItem', () {
      // given
      final pageConfig = script.pages[0] as PageConfig.Page;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: 'document/Person/default',
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
        partLibrary: partLibrary,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId, isNull);
      expect(page.route, 'document/Person/default');
    });
    test('single page, tagged DataItemById, tagged Page', () {
      // given
      final pageConfig = script.pages[1] as PageConfig.Page;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItemById>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: 'document/Person/MyObject/shortForm',
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
        partLibrary: partLibrary,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId,
          (pageConfig.dataSelectors[0] as DataItemById).objectId);
      expect(page.route, 'document/Person/MyObject/shortForm');
    });
    test('single page, untagged DataItem tagged Page', () {
      // given
      final pageConfig = script.pages[1] as PageConfig.Page;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: 'document/Person/default/shortForm',
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
        partLibrary: partLibrary,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentPage>());
      final DocumentPage page = p as DocumentPage;
      expect(page.config, pageConfig);
      expect(page.objectId, isNull);
      expect(page.route, 'document/Person/default/shortForm');
    });
    test('multi page, untagged PMulti', () {
      // given
      final pageConfig = script.pages[2] as PageConfig.Page;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: 'documents/Person/default',
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
        partLibrary: partLibrary,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentListPage>());
      final DocumentListPage page = p as DocumentListPage;
      expect(page.config, pageConfig);
      expect(page.route, 'documents/Person/default');
    });
    test('multi page, tagged PMulti', () {
      // given
      final pageConfig = script.pages[5] as PageConfig.Page;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<DataItem>(
              named: 'dataSelector'))).thenReturn(MockDataContext());
      // when
      MaterialPageRoute? r = builder.buildPage(
        route: 'documents/Person/specialMembers',
        pageArguments: {},
        context: MockBuildContext(),
        parentBinding: MockDataBinding(),
        script: script,
        cache: cache,
        partLibrary: partLibrary,
      ) as MaterialPageRoute?;
      // then

      expect(r, isNotNull);
      final p = r!.buildContent(MockBuildContext());
      expect(p, isA<DocumentListPage>());
      final DocumentListPage page = p as DocumentListPage;
      expect(page.config, pageConfig);
      expect(page.route, 'documents/Person/specialMembers');
      expect(page.objectIds, ['xxx', 'yyy']);
    });
  });
}
