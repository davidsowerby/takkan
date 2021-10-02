import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/example/kitchenSink.dart';
import 'package:precept_script/example/kitchenSinkSchema.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/queryView.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/signin/signIn.dart';

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

    test('debugId and classes', () {
      // given
      final script = kitchenSinkScript;
      script.init();
      print(kitchenSinkSchema.name);
      print(script.dataProvider?.schema.name);
      final log = WalkLog();
      final classes = WalkClasses();
      // when
      script.walk([
        WalkDebugId(),
        classes,
        log,
      ]);
      // then

      StringBuffer buf = StringBuffer();
      log.calls.forEach((element) {
        buf.write('\'$element\',');
      });
      print(buf.toString());
      expect(log.calls.length, 29);
      expect(classes.calls, [
        PScript,
        PDataProvider,
        PSchema,
        PDocument,
        PPermissions,
        PPage,
        PPanel,
        PText,
        PNavButton,
        PNavButtonSet,
        PEmailSignIn,
        PGraphQLQuery,
        PQueryView,
        PPQuery,
        PPanelHeading
      ]);
      expect(log.calls, [
        'Kitchen Sink',
        'Kitchen Sink.DataProvider:0',
        'Kitchen Sink./',
        'Kitchen Sink./.Panel:0',
        'Kitchen Sink./.Panel:0.id1',
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
  step(Object entry) {
    if (entry is PreceptItem) {
      calls.add(
          entry.debugId ?? 'Null debugId in ${entry.runtimeType.toString()}');
    }
  }
}

class WalkClasses implements ScriptVisitor {
  final Set<Type> calls = Set();

  WalkClasses();

  @override
  step(Object entry) {
    calls.add(entry.runtimeType);
  }
}

class WalkDebugId implements ScriptVisitor {
  @override
  step(Object entry) {
    if (entry is PreceptItem) {
      if (entry.debugId == null) {
        String msg =
            'entry must have debugId - has the init call been cascaded? (${entry.runtimeType.toString()})';
        logType(this.runtimeType).e(msg);
        throw PreceptException(msg);
      }
    }
  }
}
