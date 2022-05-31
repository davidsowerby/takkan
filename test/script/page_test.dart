import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';
import 'package:test/test.dart';

void main() {
  group('PPage', () {
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
            documentClass: 'Person',
            dataSelectors: [
              const DataItemById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              const DataItem(caption: '?'),
            ],
          ),
          Page(
            documentClass: 'Person',
            tag: 'shortForm',
            dataSelectors: [
              const DataItemById(
                tag: 'MyObject',
                objectId: 'xxx',
              ),
              const DataItem(),
            ],
          ),
          Page(
            documentClass: 'Person',
            dataSelectors: [
              const DataList(),
            ],
          ),
          Page(
            documentClass: 'Person',
            dataSelectors: [
              const DataListByFilter(
                tag: 'members',
                script: 'member==true',
              )
            ],
          ),
          Page(
            dataSelectors: [const NoData(tag: 'home')],
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
      expect(s.routeMap.containsKey('static/home'), isTrue);
      expect(s.routeMap.containsKey('documents/Person/members'), isTrue);

      expect (s.pages[0].isStatic,isFalse);
      expect (s.pages[4].isStatic,isTrue);
    });
  });
}
