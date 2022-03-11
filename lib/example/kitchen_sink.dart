import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/select/multi.dart';
import 'package:precept_script/data/select/single.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/static_panel.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/query_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/particle/text_box.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:precept_script/signin/sign_in.dart';

final kitchenSinkScript = PScript(
  dataProvider: PDataProvider(
    instanceConfig: PInstance(group: 'test', instance: 'test'),
  ),
  name: 'Kitchen Sink',
  version: PVersion(number: 0),
  schema: PSchema(
    name: 'dummy - move from data provider',
    version: PVersion(number: -1),
  ),
  locale: 'en_GB',
  pages: [
    PPageStatic(
      routes: ['/'],
      layout: PLayoutDistributedColumn(padding: PPadding(top: 50)),
      controlEdit: ControlEdit.panelsOnly,
      caption: 'Home Page',
      children: [
        PPanelStatic(
          layout: PLayoutDistributedColumn(preferredColumnWidth: 350),
          children: [
            PText(
              id: 'id1',
              readTraitName: PText.heading1,
              staticData: 'Welcome to Precept',
            ),
            PText(
              readTraitName: PText.heading3,
              staticData: 'Proof of Concept',
            ),
            PNavButton(
              height: 101,
              staticData: 'OK',
              route: 'chooseList',
            ),
          ],
        ),
      ],
    ),
    PPageStatic(
      routes: ['signIn'],
      caption: 'Sign In',
      children: [
        PNavButtonSet(
          buttons: {'email': 'emailSignIn'},
        ),
      ],
    ),
    PPageStatic(
        routes: ['emailSignIn'],
        caption: 'Email Sign In',
        children: [PEmailSignIn()]),
    PPageStatic(
      routes: ['chooseList'],
      layout: PLayoutDistributedColumn(padding: PPadding(top: 50)),
      caption: 'Select List to View',
      children: [
        PNavButtonSet(
          buttons: {
            'Open Issues': 'openIssues',
            'Closed Issues': 'closedIssues',
            'Search Issues': 'search',
            'Account': 'account',
          },
          width: 150,
        ),
      ],
    ),
    PPage(
      controlEdit: ControlEdit.panelsOnly,
      caption: 'Open Issues',
      dataSelectors: [
        PMultiByGQL(
          caption: 'Open Issues',
          tag: 'openIssues',
          script: openIssuesScript,
        )
      ],
      children: [
        PPanelStatic(
          caption: 'test',
          children: [
            PQueryView(
              queryName: 'openIssues',
              caption: 'Open Issues',
              subtitleProperty: 'description',
            )
          ],
        ),
      ],
    ),
    PPageStatic(
      routes: ['account'],
      caption: 'Account',
      children: [
        PPanel(
          heading: PPanelHeading(canEdit: true, expandable: true),
          property: '',
          dataSelectors: [
            PSingleById(
                caption: 'My Object', tag: 'MyObject', objectId: 'wVdGK8TDXR')
          ],
          caption: 'Account',
          children: [
            PText(
              property: 'accountNumber',
              readOnly: true,
              caption: 'Account Number',
            ),
            PText(
              property: 'category',
              caption: 'Category',
              editTraitName: PTextBox.defaultTraitName,
            ),
          ],
        ),
      ],
    ),
    PPageStatic(
      routes: ['search'],
      caption: 'Search Issues',
      children: [],
    ),
    PPageStatic(
      routes: ['issue'],
      caption: 'Issue',
      children: [
        PPanelStatic(
          caption: 'Issue',
          heading: PPanelHeading(),
          children: [
            PText(
              readOnly: true,
              property: 'title',
              caption: 'Title',
              help: PHelp(title: 'Title', message: 'Keep it short and punchy'),
            ),
            PText(
              property: 'description',
              caption: 'Description',
              help: PHelp(title: 'Description', message: 'Lots of  details'),
            ),
          ],
        ),
      ],
    ),
  ],
);

final openIssuesScript = r'''data-select OpenIssues {
  issues(where: { state: {equalTo: "open"} }) {
    count
    edges {
      node {
        state
        title
        description
        objectId
        id
        priority
        number
        createdAt
        updatedAt
      }
    }
  }
}''';
