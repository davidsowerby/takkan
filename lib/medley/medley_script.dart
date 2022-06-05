import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/part/list_view.dart';
import 'package:takkan_script/part/navigation.dart';
import 'package:takkan_script/part/text.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/script/version.dart';

import 'medley_schema.dart';

final List<Script> medleyScript = [
  medleyScript0,
  medleyScript1,
  medleyScript2,
];

/// Changes:
/// - Authentication added (see [medleySchema1])
/// - Validation changes (see [medleySchema1])
final Script medleyScript2 = Script(
  name: 'Medley',
  version: Version(number: 1, label: '0.0.1-draft'),
  schema: medleySchema[1],
  dataProvider: DataProvider(
    instanceConfig: AppInstance(group: 'main'),
    useAuthenticator: true,
  ),
  pages: [
    Page(name: 'home', caption: 'Home', dataSelectors: [
      NoData(name: 'home')
    ], children: [
      Group(children: [
        Title(
          staticData: 'Takkan',
        ),
        Subtitle(
          staticData: 'Proof of Concept',
        ),
        Subtitle2(
          staticData: 'A brief introduction to faster Flutter development',
        ),
        NavButton(
          caption: 'OK',
          toPage: 'issue',
          toData: 'topIssue',
        ),
      ])
    ]),
    Page(
      name: 'issue',
      controlEdit: ControlEdit.pagesOnly,
      caption: 'Issue',
      documentClass: 'Issue',
      dataSelectors: [DataItemById(objectId: 'JJoGIErtzn', name: 'topIssue')],
      children: [
        Group(children: [
          BodyText1(
            property: 'title',
            caption: 'Title',
          ),
          BodyText2(
            property: 'description',
            caption: 'Description',
          ),
          BodyText2(
            property: 'weight',
            caption: 'Weight',
          ),
        ])
      ],
    ),
    Page(name: 'issues', caption: 'Issues', dataSelectors: [
      DataList(caption: 'All Issues', name: 'allIssues'),
    ], children: [
      ListView(
        property: 'results',
        titleProperty: 'title',
        subtitleProperty: 'description',
      )
    ])
  ],
);
final Script medleyScript1 = Script(
  name: 'Medley',
  version: Version(number: 1, label: '0.0.1-draft'),
  schema: medleySchema[0],
  dataProvider: DataProvider(
    instanceConfig: AppInstance(group: 'main', instance: 'dev'),
  ),
  pages: [
    Page(name: 'home', caption: 'Home', dataSelectors: [
      NoData(name: 'home'),
    ], children: [
      Title(
        staticData: 'Takkan',
      ),
      Subtitle(
        staticData: 'Proof of Concept',
      ),
      Subtitle2(
        staticData: 'A brief introduction to faster Flutter development',
      ),
      NavButton(
        caption: 'OK',
        toPage: 'person',
        toData: 'topIssue',
      ),
    ]),
    Page(
      name: 'person',
      caption: 'Person',
      dataSelectors: [
        NoData(name: 'person'),
      ],
      children: [
        BodyText1(
          property: 'firstName',
          caption: 'First Name',
          staticData: 'Michael',
        ),
        BodyText2(
          property: 'age',
          caption: 'age',
          staticData: '17',
        ),
      ],
    ),
  ],
);

/// '/': Static data only, with a field for each supported data type
/// 'Person' :
/// - Single document, dynamic data
/// - Should open blank without error
/// - page level 'Create new' button should be present
/// - age field,  caption is not specified, should take up property name
///
///
final Script medleyScript0 = Script(
  name: 'Medley',
  version: Version(number: 0, label: '0.0.0-draft'),
  schema: medleySchema[0],
  dataProvider: DataProvider(
    instanceConfig: AppInstance(group: 'main', instance: 'dev'),
  ),
  pages: [
    Page(
      name: 'home',
      caption: 'Home',
      dataSelectors: [
        NoData(name: 'home'),
      ],
      children: [
        Title(
          staticData: 'Takkan',
        ),
        Subtitle(
          staticData: 'Proof of Concept',
        ),
        Subtitle2(
          staticData: 'A brief introduction to faster Flutter development',
        ),
        NavButton(
          caption: 'OK',
          toPage: 'persons',
          toData: 'allIssues',
        ),
      ],
    ),
    Page(
      name: 'person',
      caption: 'Person',
      dataSelectors: [
        NoData(name: 'person'),
      ],
      children: [
        BodyText1(
          property: 'firstName',
          caption: 'First Name',
          staticData: 'Michael',
        ),
        BodyText2(
          property: 'age',
          caption: 'age',
          staticData: '17',
        ),
      ],
    ),
    Page(
      name: 'persons',
      caption: 'Person',
      dataSelectors: [
        NoData(name: 'persons'),
      ],
      children: [
        BodyText1(
          property: 'firstName',
          caption: 'First Name',
          staticData: 'Michael',
        ),
        BodyText2(
          property: 'age',
          caption: 'age',
          staticData: '17',
        ),
      ],
    )
  ],
);
