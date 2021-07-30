import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/queryView.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/particle/textBox.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/signin/signIn.dart';

final kitchenSinkScript = PScript(
  dataProvider: PNoDataProvider(),
  name: 'Kitchen Sink',
  locale: 'en_GB',
  pages: {
    '/': PPage(
      layout: PPageLayout(margins: PMargins(top: 50)),
      controlEdit: ControlEdit.panelsOnly,
      title: 'Home Page',
      content: [
        PPanel(
          layout: PPanelLayout(width: 350),
          content: [
            PText(
              readTraitName: PText.heading1,
              isStatic: IsStatic.yes,
              staticData: 'Welcome to Precept',
            ),
            PText(
              readTraitName: PText.heading3,
              isStatic: IsStatic.yes,
              staticData: 'Proof of Concept',
            ),
            PNavButton(
              isStatic: IsStatic.yes,
              staticData: 'OK',
              route: 'chooseList',
            ),
          ],
        ),
      ],
    ),
    'signIn': PPage(
      title: 'Sign In',
      isStatic: IsStatic.yes,
      content: [
        PNavButtonSet(
          buttons: {'email': 'emailSignIn'},
        ),
      ],
    ),
    'emailSignIn': PPage(title: 'Email Sign In', content: [PEmailSignIn()]),
    'chooseList': PPage(
      layout: PPageLayout(margins: PMargins(top: 50)),
      title: 'Select List to View',
      content: [
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
    'openIssues': PPage(
      controlEdit: ControlEdit.panelsOnly,
      title: 'Open Issues',
      query: PGraphQLQuery(
        querySchema: 'openIssues',
        script: openIssuesScript,
        returnType: QueryReturnType.futureList,
      ),
      content: [
        PPanel(
          property: '',
          caption: 'test',
          content: [
            PQueryView(
              queryName: 'openIssues',
              caption: 'Open Issues',
              subtitleProperty: 'description',
            )
          ],
        ),
      ],
    ),
    'account': PPage(
      title: 'Account',
      content: [
        PPanel(
          heading: PPanelHeading(canEdit: true, expandable: true),
          property: '',
          query: PPQuery(
            querySchema: 'Get Account',
            fields: 'id,objectId, category,accountNumber,createdAt,updatedAt',
            variables: {'id': 'wVdGK8TDXR'},
            types: {
              'id': 'ID!',
            },
          ),
          caption: 'Account',
          content: [
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
    'search': PPage(
      title: 'Search Issues',
      content: [],
    ),
    'Issue': PPage(
      title: 'Issue',
      content: [
        PPanel(
          caption: 'Issue',
          heading: PPanelHeading(),
          property: '',
          content: [
            PText(
              readOnly: true,
              isStatic: IsStatic.no,
              property: 'title',
              caption: 'Title',
              help: PHelp(title: 'Title', message: 'Keep it short and punchy'),
            ),
            PText(
              isStatic: IsStatic.no,
              property: 'description',
              caption: 'Description',
              help: PHelp(title: 'Description', message: 'Lots of  details'),
            ),
          ],
        ),
      ],
    ),
  },
);

final openIssuesScript = r'''query OpenIssues {
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
