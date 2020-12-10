import 'package:precept_client/precept/script/data.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:test/test.dart';

void main() {
  group('PScript validation', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('Insufficient components', () {
      // given
      final script1 = PScript();
      final script2= PScript(components: []);
      // when
      final result = script1.validate();
      // then

      expect(result.length, 1);
      expect(result[0].toString(),
          'PScript : n/a : A PScript instance must contain at least one component');
    });

    group('PComponent validation', () {
      test('routes and name not null', () {
        // given
        final component = PScript(components: [PComponent()]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PComponent : n/a : PComponent at index 0 must have a name defined');
        expect(messages[1].toString(),
            "PComponent : n/a : PComponent at index 0 must contain at least one PRoute");
      });

      test('routes and name must not be not empty', () {
        // given
        final component = PScript(components: [PComponent(name: '')]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PComponent : n/a : PComponent at index 0 must have a name defined');
        expect(messages[1].toString(),
            "PComponent : n/a : PComponent at index 0 must contain at least one PRoute");
      });
    });

    group('PRoute validation', () {
      test('Must have path and page', () {
        // given
        final component = PScript(components: [
          PComponent(name: 'core', routes: [PRoute()])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(),
            'PRoute : n/a : PRoute at index 0 of PComponent core must define a path');
        expect(messages[1].toString(),
            "PRoute : n/a : PRoute at index 0 of PComponent core must define a page");
      });
    });

    group('PPage validation', () {
      test('Must have pageType and title', () {
        // given
        final component = PScript(components: [
          PComponent(name: 'core', routes: [PRoute(path: "/home", page: PPage(pageType: null))])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 2);
        expect(messages[0].toString(), 'PPage : n/a : PPage at PRoute /home must define a title');
        expect(messages[1].toString(), 'PPage : n/a : PPage at PRoute /home must define a pageType');
      });

      test('No errors', () {
        // given
        final component = PScript(components: [
          PComponent(name: 'core', routes: [PRoute(path: "/home", page: PPage(pageType: "mine",title: "Wiggly", dataSource: PDataGet(id: DocumentId())))])
        ]);
        // when
        final messages = component.validate();
        // then

        expect(messages.length, 0);
      });
    });
  });
}
