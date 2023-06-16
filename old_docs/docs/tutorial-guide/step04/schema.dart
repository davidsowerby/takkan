// import 'package:precept_script/schema/field/integer.dart';
// import 'package:precept_script/schema/field/queryResult.dart';
// import 'package:precept_script/schema/field/string.dart';
// import 'package:precept_script/schema/schema.dart';
//
// final back4appSchema = PSchema(
//   name: 'issuesSchema',
//   documents: {
//     'Issue': PDocument(
//       permissions: PPermissions(
//           requiresAuthentication: [RequiresAuth.all], updateRoles: ['editor']),
//       fields: {
//         'title': PString(),
//         'description': PString(),
//         'number': PInteger(),
//         'priority': PInteger(),
//         'state': PString(),
//       },
//     ),
//   },
//   queries: {
//     'openIssues': PQuerySchema(documentSchema: 'Issue'),
//   },
// );
