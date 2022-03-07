import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:precept_client/app/page_builder.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/data/document_cache.dart';
import 'package:precept_client/library/part_library.dart';
import 'package:precept_client/page/document_list_page.dart';
import 'package:precept_client/page/document_page.dart';
import 'package:precept_client/page/static_page.dart';
import 'package:precept_script/data/select/multi.dart';
import 'package:precept_script/data/select/single.dart';
import 'package:precept_script/page/page.dart';
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
  late PScript script;
  registerFallbackValue(NullDataContext());
  registerFallbackValue(PSingleById(objectId: 'x'));
  registerFallbackValue(PSingle());
  group('PageBuilder', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      script = PScript(
        name: 'test',
        version: PVersion(number: 0),
        schema: PSchema(
          version: PVersion(number: 0),
          name: 'test',
          documents: {'Person': PDocument(fields: {})},
        ),
        pages: [
          PPage(
            documentClass: 'Person',
            dataSelectors: [
              PSingleById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              PSingle(),
            ],
          ),
          PPage(
            documentClass: 'Person',
            tag: 'shortForm',
            dataSelectors: [
              PSingleById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              PSingle(),
            ],
          ),
          PPage(
            documentClass: 'Person',
            dataSelectors: [
              PMulti(),
            ],
          ),
          PPage(
            documentClass: 'Person',
            dataSelectors: [
              PMultiByFilter(
                tag: 'members',
                script: 'member==true',
              )
            ],
          ),
          PPageStatic(
            routes: ['static page'],
          ),
          PPage(
            documentClass: 'Person',
            dataSelectors: [
              PMultiById(
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
    test('single page, tagged PSingleById', () {
      // given
      final pageConfig = script.pages[0] as PPage;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<PSingleById>(
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
      expect(
          page.objectId, (pageConfig.dataSelectors[0] as PSingleById).objectId);
      expect(page.route, 'document/Person/MyObject');
    });
    test('single page, untagged PSingle', () {
      // given
      final pageConfig = script.pages[0] as PPage;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<PSingle>(
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
    test('single page, tagged PSingleById, tagged Page', () {
      // given
      final pageConfig = script.pages[1] as PPage;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<PSingleById>(
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
      expect(
          page.objectId, (pageConfig.dataSelectors[0] as PSingleById).objectId);
      expect(page.route, 'document/Person/MyObject/shortForm');
    });
    test('single page, untagged PSingle tagged Page', () {
      // given
      final pageConfig = script.pages[1] as PPage;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<PSingle>(
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
      final pageConfig = script.pages[2] as PPage;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<PSingle>(
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
      final pageConfig = script.pages[5] as PPage;
      when(() => cache.dataContext(
          parentDataContext: any<NullDataContext>(named: 'parentDataContext'),
          config: pageConfig,
          dataSelector: any<PSingle>(
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
