import 'package:precept_script/data/select/multi.dart';
import 'package:precept_script/data/select/single.dart';
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
      PScript s = PScript(
        name: 'test',
        version: PVersion(number: 0),
        schema: PSchema(
          version: PVersion(number: 0),
          name: 'test',
        ),
        pages: [
          PPage(
            documentClass: 'Person',
            dataSelectors: [
              PSingleById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              PSingle(caption: '?'),
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
            dataSelectors: [PMulti(),],
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
