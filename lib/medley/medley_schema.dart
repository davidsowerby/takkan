import 'package:takkan_script/data/select/condition/condition.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/version.dart';

/// There are a lot of versions here.  It is structured this way to try and cover
/// all the permutations of changes which can occur between one version and another.
/// This is to support testing of diff and code generation
///
/// It is possible to use one of these versions as the basis of an example app but
/// that is not its primary purpose.
final List<Schema> medleySchema = [medleySchema2,medleySchema1, medleySchema0];
final Schema medleySchema0 = Schema(
  name: 'medley',
  version: Version(number: 0),
  documents: {
    'Person': Document(fields: {
      'firstName': FString(),
      'age': FInteger(validation: '>0 && <100', required: true),
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
/// - Person.first name : field added
///
/// TODO: require authentication
final Schema medleySchema1 = Schema(
  name: 'medley',
  version: Version(number: 1, deprecated: [0]),
  documents: {
    'Person': Document(fields: {
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
    },),
    'Issue': Document(fields: {
      'title': FString(required: true),
      'description': FString(
        constraints: [
          V.string.longerThan(5),
          V.string.shorterThan(128),
        ],
      ),
      'weight': FInteger(
        constraints: [
          V.int.greaterThan(0),
          V.int.lessThan(6),
        ],
      ),
      'state': FString(),
    }, queries: {
      'allIssues': (q) => const []
    }, queryScripts: {
      'topIssue': "objectId=='JJoGIErtzn'"
    })
  },
);
final Schema medleySchema2 = Schema(
  name: 'medley',
  version: Version(number: 2, deprecated: [0]),
  documents: {
    'Person': Document(fields: {
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
    },),
    'Issue': Document(fields: {
      'title': FString(required: true),
      'description': FString(
        constraints: [
          V.string.longerThan(5),
          V.string.shorterThan(128),
        ],
      ),
      'weight': FInteger(
        constraints: [
          V.int.greaterThan(0),
          V.int.lessThan(6),
        ],
      ),
      'state': FString(),
    }, queries: {
      'allIssues': (q) => const []
    }, queryScripts: {
      'topIssue': "objectId=='xxx'"
    })
  },
);
