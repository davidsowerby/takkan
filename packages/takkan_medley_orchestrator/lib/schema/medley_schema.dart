

import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/query/query.dart';
import 'package:takkan_schema/schema/schema.dart';

/// There are a lot of versions here.  It is structured this way to try and cover
/// all the permutations of changes which can occur between one version and another.
/// This is to support testing of diff and code generation
///
/// It is possible to use one of these versions as the basis of an example app but
/// that is not its primary purpose.
final List<Schema> medleySchema = [medleySchema2, medleySchema1, medleySchema0];
final List<Schema> schemaVersions = [medleySchema2, medleySchema1, medleySchema0];
final Schema medleySchema0 = Schema(
  version: Version(versionIndex: 0),
  documents: {
    'Person': Document(fields: {
      'firstName': Field<String>(),
      'age': Field<int>(validation: '> 0 && < 100', required: true),
      'height': Field<int>(
        constraints: [
          V.int.greaterThan(0),
        ],
        required: false,
      ),
      'siblings':
          Field<int>(constraints: [V.int.greaterThan(-1)], defaultValue: 0),
    })
  },
);

/// Changes:
/// - Person.age : validation changed
/// - Person.height : validation added
/// - Person.siblings : validation removed
/// - Person.lastName : field added
/// - Person.firstName : required
///
/// TODO: require authentication
final Schema medleySchema1 = Schema(
  version: Version(versionIndex: 1),
  documents: {
    'Person': Document(
      fields: {
        'firstName': Field<String>(required: true),
        'lastName': Field<String>(),
        'age': Field<int>(
          required: true,
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(128),
          ],
        ),
        'height': Field<int>(constraints: [
          V.int.greaterThan(0),
          V.int.lessThan(300),
        ]),
        'siblings': Field<int>(constraints: []),
      },
    ),
    'Issue': Document(
      fields: {
        'title': Field<String>(required: true),
        'description': Field<String>(
          constraints: [
            V.string.lengthGreaterThan(5),
            V.string.lengthLessThan(128),
          ],
        ),
        'weight': Field<int>(
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(6),
          ],
        ),
        'state': Field<String>(),
      },
      queries: {
        'allIssues': Query(returnSingle: false, constraints: const []),
        'topIssue': Query(
            queryScript: "objectId == 'JJoGIErtzn'",
            returnSingle: true,
            constraints: []),
      },
    )
  },
);

final Schema medleySchema2 = Schema(
  version: Version(versionIndex: 2,),
  documents: {
    'Person': Document(
      fields: {
        'firstName': Field<String>(required: true, constraints: [V.string.lengthGreaterThan(1)]),
        'lastName': Field<String>(),
        'age': Field<int>(
          required: true,
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(128),
          ],
        ),
        'height': Field<int>(constraints: [
          V.int.greaterThan(0),
          V.int.lessThan(300),
        ]),
        'siblings': Field<int>(constraints: []),
      },
    ),
    'Issue': Document(
      fields: {
        'title': Field<String>(required: true),
        'description': Field<String>(
          constraints: [
            V.string.lengthGreaterThan(5),
            V.string.lengthLessThan(128),
          ],
        ),
        'weight': Field<int>(
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(6),
          ],
        ),
        'state': Field<String>(),
        // 'raisedBy' : FPointer(targetClass: 'Person'),
      },
      queries: {
        'allIssues': Query(),
        'topIssue': Query(
          queryScript: "objectId == 'xxx'",
          returnSingle: true,
        )
      },
    )
  },
);
