import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/select/multi.dart';
import 'package:precept_script/data/select/single.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/part/list_view.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';

import 'medley_schema.dart';

final List<PScript> medleyScript = [
  medleyScript0,
  medleyScript1,
  medleyScript2,
];

/// Changes:
/// - Authentication added (see [medleySchema1])
/// - Validation changes (see [medleySchema1])
final PScript medleyScript2 = PScript(
  name: 'Medley',
  version: PVersion(number: 1, label: '0.0.1-draft'),
  schema: medleySchema[1],
  dataProvider: PDataProvider(
    instanceConfig: PInstance(group: 'main'),useAuthenticator: true,
  ),
  pages: [
    PPageStatic(caption: 'Home', routes: [
      '/'
    ], children: [
      PText(
        readTraitName: PText.title,
        staticData: 'Precept',
      ),
      PText(
        readTraitName: PText.subtitle,
        staticData: 'Proof of Concept',
      ),
      PText(
        readTraitName: PText.strapText,
        staticData: 'A brief introduction to faster Flutter development',
      ),
      PNavButton(
        staticData: 'OK',
        route: 'document/Issue/Top Issue',
      ),
    ]),
    PPage(controlEdit: ControlEdit.pagesOnly,
      caption: 'Issue',
      documentClass: 'Issue',
      dataSelectors: [PSingleById(objectId: 'JJoGIErtzn',tag: 'Top Issue')],
      children: [
        PText(
          property: 'title',
          caption: 'Title',
        ),
        PText(
          property: 'description',
          caption: 'Description',
        ),
        PText(
          property: 'weight',
          caption: 'Weight',
        ),
      ],
    ),
    PPage(caption: 'Issues', dataSelectors: [
      PMulti(caption: 'All Issues', tag: 'allIssues'),
    ], children: [
      PListView(
        property: 'results',
        titleProperty: 'title',
        subtitleProperty: 'description',
      )
    ])
  ],
);
final PScript medleyScript1 = PScript(
  name: 'Medley',
  version: PVersion(number: 1, label: '0.0.1-draft'),
  schema: medleySchema[0],
  dataProvider: PDataProvider(
    instanceConfig: PInstance(group: 'main', instance: 'dev'),
  ),
  pages: [
    PPageStatic(caption: 'Home', routes: [
      '/'
    ], children: [
      PText(
        readTraitName: PText.title,
        staticData: 'Precept',
      ),
      PText(
        readTraitName: PText.subtitle,
        staticData: 'Proof of Concept',
      ),
      PText(
        readTraitName: PText.strapText,
        staticData: 'A brief introduction to faster Flutter development',
      ),
      PNavButton(
        staticData: 'OK',
        route: 'person',
      ),
    ]),
    PPageStatic(
      caption: 'Person',
      routes: ['person'],
      children: [
        PText(
          property: 'firstName',
          caption: 'First Name',
          staticData: 'Michael',
        ),
        PText(
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
final PScript medleyScript0 = PScript(
  name: 'Medley',
  version: PVersion(number: 0, label: '0.0.0-draft'),
  schema: medleySchema[0],
  dataProvider: PDataProvider(
    instanceConfig: PInstance(group: 'main', instance: 'dev'),
  ),
  pages: [
    PPageStatic(caption: 'Home', routes: [
      '/'
    ], children: [
      PText(
        readTraitName: PText.title,
        staticData: 'Precept',
      ),
      PText(
        readTraitName: PText.subtitle,
        staticData: 'Proof of Concept',
      ),
      PText(
        readTraitName: PText.strapText,
        staticData: 'A brief introduction to faster Flutter development',
      ),
      PNavButton(
        staticData: 'OK',
        route: 'persons',
      ),
    ]),
    PPageStatic(
      caption: 'Person',
      routes: ['person'],
      children: [
        PText(
          property: 'firstName',
          caption: 'First Name',
          staticData: 'Michael',
        ),
        PText(
          property: 'age',
          caption: 'age',
          staticData: '17',
        ),
      ],
    ),
    PPageStatic(caption: 'Person', routes: [
      'persons'
    ], children: [
      PText(
        property: 'firstName',
        caption: 'First Name',
        staticData: 'Michael',
      ),
      PText(
        property: 'age',
        caption: 'age',
        staticData: '17',
      ),
    ])
  ],
);
