
import 'package:collection/collection.dart';
import 'package:precept/precept/document/documentController.dart';
import 'package:test/test.dart';

void main() {
  List<EventMatcher> matchers;
  group('Document Controller', () {
    setUpAll(() {
      StreamCreator creator = StreamCreator();
      matchers=creator.snapshots.map((e) => EventMatcher(e)).toList();
    });

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('StreamCreator', () {
      // given
      StreamCreator creator = StreamCreator();
      // when
      // Stream<Map<String, dynamic>> stream =
      //     creator.start(Duration(seconds: 1), 10);
      final stream = Stream.fromIterable(creator.snapshots);
      // then
      expect(stream, emitsInOrder(matchers));
    });
  });
}

class EventMatcher extends Matcher {
  Map<String, dynamic> expected;
  Map<String, dynamic> actual;

  EventMatcher(this.expected);

  @override
  Description describe(Description description) {
    return description.add("has expected word content = '$expected'");
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map<dynamic, dynamic> matchState, bool verbose) {
    return mismatchDescription.add("item was $item, matchState was $matchState");
  }

  @override
  bool matches(actual, Map matchState) {
    this.actual = actual;
    MapEquality me=MapEquality();
    final result = me.equals(actual, this.expected);
    // print("actual: $actual......... expected: ${this.expected} ....... result: $result");
    return result;
  }
}
