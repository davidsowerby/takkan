// import 'package:precept_back4app_backend/backend/back4app/dataProvider/pBack4AppDataProvider.dart';
// import 'package:precept_script/common/script/common.dart';
// import 'package:precept_script/common/script/layout.dart';
// import 'package:precept_script/data/provider/dataProvider.dart';
// import 'package:precept_script/panel/panel.dart';
// import 'package:precept_script/part/navigation.dart';
// import 'package:precept_script/part/queryView.dart';
// import 'package:precept_script/part/text.dart';
// import 'package:precept_script/query/query.dart';
// import 'package:precept_script/script/script.dart';
// import 'package:precept_tutorial/app/config/schema.dart';
// import 'package:precept_tutorial/app/query/issue.dart';
//
// final myScript = PScript(
//   name: 'Tutorial',
//   dataProvider: PBack4AppDataProvider(
//     configSource: PConfigSource(
//       segment: 'back4app',
//       instance: 'dev',
//     ),
//     schema: back4appSchema,
//   ),
//   routes: {
//     '/': PPage(
//       title: 'Home Page',
//       content: [
//         PText(
//           readTraitName: PText.title,
//           isStatic: IsStatic.yes,
//           staticData: 'Precept',
//         ),
//         PText(
//           readTraitName: PText.subtitle,
//           isStatic: IsStatic.yes,
//           staticData: 'Proof of Concept',
//         ),
//         PText(
//           readTraitName: PText.strapText,
//           isStatic: IsStatic.yes,
//           staticData: 'A brief introduction to faster Flutter development',
//         ),
//         PNavButton(
//           isStatic: IsStatic.yes,
//           staticData: 'OK',
//           route: 'chooseList',
//         ),
//       ],
//     ),
//     'chooseList': PPage(
//       layout: PPageLayout(margins: PMargins(top: 50)),
//       title: 'Select List to View',
//       content: [
//         PNavButtonSet(
//           buttons: {
//             'Open Issues': 'openIssues',
//             'Closed Issues': 'closedIssues',
//             'Search Issues': 'search',
//             'Account': 'account',
//           },
//         ),
//       ],
//     ),
//     'openIssues': PPage(
//       controlEdit: ControlEdit.panelsOnly,
//       title: 'Open Issues',
//       query: PGraphQLQuery(
//         querySchemaName: 'openIssues',
//         script: openIssuesGQL,
//         returnType: QueryReturnType.futureList,
//       ),
//       content: [
//         PPanel(
//           property: '',
//           caption: 'test',
//           content: [
//             PQueryView(
//               queryName: 'openIssues',
//               caption: 'Open Issues',
//               subtitleProperty: 'description',
//             )
//           ],
//         ),
//       ],
//     ),
//   },
// );
