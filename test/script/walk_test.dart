import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/example/kitchenSink.dart';
import 'package:precept_script/inject/inject.dart';

import '../fixtures.dart';

void main() {
  group('Walking', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {
      getIt.reset();
      getIt.registerFactory<PreceptSchemaLoader>(
          () => FakePreceptSchemaLoader());
    });

    tearDown(() {});

    test('output', () {
      // given
      final script = kitchenSinkScript;
      script.init();
      final log = WalkLog();
      // when
      script.walk([
        WalkDebugId(),
        log,
      ]);
      // then

      // StringBuffer buf=StringBuffer();
      // log.calls.forEach((element) {
      //   buf.write('\'$element\',');
      // });
      // print(buf.toString());
      expect(log.calls.length, 30);
      expect(log.calls, [
        'Kitchen Sink',
        'Kitchen Sink.NoDataProvider:0',
        'Kitchen Sink.SchemaSource:0',
        'Kitchen Sink./',
        'Kitchen Sink./.Panel:0',
        'Kitchen Sink./.Panel:0.Text:0',
        'Kitchen Sink./.Panel:0.Text:1',
        'Kitchen Sink./.Panel:0.NavButton:2',
        'Kitchen Sink.signIn',
        'Kitchen Sink.signIn.NavButtonSet:0',
        'Kitchen Sink.emailSignIn',
        'Kitchen Sink.emailSignIn.Sign in with Email',
        'Kitchen Sink.chooseList',
        'Kitchen Sink.chooseList.NavButtonSet:0',
        'Kitchen Sink.openIssues',
        'Kitchen Sink.openIssues.GraphQLQuery:4',
        'Kitchen Sink.openIssues.test',
        'Kitchen Sink.openIssues.test.Open Issues',
        'Kitchen Sink.account',
        'Kitchen Sink.account.Account',
        'Kitchen Sink.account.Account.PQuery:0',
        'Kitchen Sink.account.Account.PanelHeading:0',
        'Kitchen Sink.account.Account.Account Number',
        'Kitchen Sink.account.Account.Category',
        'Kitchen Sink.search',
        'Kitchen Sink.Issue',
        'Kitchen Sink.Issue.Issue',
        'Kitchen Sink.Issue.Issue.PanelHeading:0',
        'Kitchen Sink.Issue.Issue.Title',
        'Kitchen Sink.Issue.Issue.Description',
      ]);
    });
  });
}

class WalkLog implements ScriptVisitor {
  final List<String> calls = List.empty(growable: true);

  WalkLog();

  @override
  step(PreceptItem entry) {
    calls.add(entry.debugId!);
  }
}

class WalkDebugId implements ScriptVisitor {
  @override
  step(PreceptItem entry) {
    if (entry.debugId == null) {
      String msg =
          'entry must have debugId - has the init call been cascaded? (${entry.runtimeType.toString()})';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
  }
}
