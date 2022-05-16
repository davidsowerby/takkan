import 'package:precept_script/data/select/data_item.dart';
import 'package:precept_script/data/select/data_list.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('PPage', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('autoRoute', () {
      // given
      Script s = Script(
        name: 'test',
        version: Version(number: 0),
        schema: Schema(
          version: Version(number: 0),
          name: 'test',
        ),
        pages: [
          Page(
            documentClass: 'Person',
            dataSelectors: [
              DataItemById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              DataItem(caption: '?'),
            ],
          ),
          Page(
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
          Page(
            documentClass: 'Person',
            dataSelectors: [
              DataList(),
            ],
          ),
          Page(
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
          )
        ],
      );

      // when
      s.init();
      // then

      expect(s.routeMap.length,7);
      expect(s.routeMap.containsKey('document/Person/MyObject'), isTrue);
      expect(s.routeMap.containsKey('document/Person/MyObject/shortForm'), isTrue);
      expect(s.routeMap.containsKey('document/Person/default/shortForm'), isTrue);
      expect(s.routeMap.containsKey('document/Person/default'), isTrue);
      expect(s.routeMap.containsKey('documents/Person/default'), isTrue);
      expect(s.routeMap.containsKey('static page'), isTrue);
      expect(s.routeMap.containsKey('documents/Person/members'), isTrue);

      expect (s.pages[0].isStatic,isFalse);
      expect (s.pages[4].isStatic,isTrue);
    });
  });
}
