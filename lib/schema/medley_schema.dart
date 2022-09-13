

import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/field/integer.dart';
import 'package:takkan_schema/schema/field/string.dart';
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
  name: 'medley',
  version: Version(number: 0),
  documents: {
    'Person': Document(fields: {
      'firstName': FString(),
      'age': FInteger(validation: '> 0 && < 100', required: true),
      'height': FInteger(
        constraints: [
          V.int.greaterThan(0),
        ],
        required: false,
      ),
      'siblings':
          FInteger(constraints: [V.int.greaterThan(-1)], defaultValue: 0),
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
  name: 'medley',
  version: Version(number: 1, deprecated: [0]),
  documents: {
    'Person': Document(
      fields: {
        'firstName': FString(required: true),
        'lastName': FString(),
        'age': FInteger(
          required: true,
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(128),
          ],
        ),
        'height': FInteger(constraints: [
          V.int.greaterThan(0),
          V.int.lessThan(300),
        ]),
        'siblings': FInteger(constraints: []),
      },
    ),
    'Issue': Document(
      fields: {
        'title': FString(required: true),
        'description': FString(
          constraints: [
            V.string.lengthGreaterThan(5),
            V.string.lengthLessThan(128),
          ],
        ),
        'weight': FInteger(
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(6),
          ],
        ),
        'state': FString(),
      },
      queries: {
        'allIssues': Query(returnSingle: false, conditions: const []),
        'topIssue': Query(
            queryScript: "objectId == 'JJoGIErtzn'",
            returnSingle: true,
            conditions: []),
      },
    )
  },
);

final Schema medleySchema2 = Schema(
  name: 'medley',
  version: Version(number: 2, deprecated: [0]),
  documents: {
    'Person': Document(
      fields: {
        'firstName': FString(required: true, constraints: [V.string.lengthGreaterThan(1)]),
        'lastName': FString(),
        'age': FInteger(
          required: true,
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(128),
          ],
        ),
        'height': FInteger(constraints: [
          V.int.greaterThan(0),
          V.int.lessThan(300),
        ]),
        'siblings': FInteger(constraints: []),
      },
    ),
    'Issue': Document(
      fields: {
        'title': FString(required: true),
        'description': FString(
          constraints: [
            V.string.lengthGreaterThan(5),
            V.string.lengthLessThan(128),
          ],
        ),
        'weight': FInteger(
          constraints: [
            V.int.greaterThan(0),
            V.int.lessThan(6),
          ],
        ),
        'state': FString(),
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
