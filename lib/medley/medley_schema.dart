import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/version.dart';

/// There are a lot of versions here.  It is structured this way to try and cover
/// all the permutations of changes which can occur between one version and another.
/// This is to support testing of diff and code generation
///
/// It is possible to use one of these version as the basis of an example app but
/// that is not its primary purpose.
final List<Schema> medleySchema = [medleySchema0, medleySchema1];

final Schema medleySchema0 = Schema(
  name: 'medley',
  version: Version(number: 0),
  documents: {
    'Person': Document(fields: {
      'firstName': FString(),
      'age': FInteger(validations: [
        VInteger.greaterThan(0),
        VInteger.lessThan(100),
      ], required: true),
      'height': FInteger(validations: [
        VInteger.greaterThan(0),
      ], required: false),
      'siblings': FInteger(validations: [
        VInteger.greaterThan(-1),
      ], defaultValue: 0),
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
      'firstName': FString(),
      'age': FInteger(validations: [
        VInteger.greaterThan(0),
        VInteger.lessThan(128),
      ]),
      'height': FInteger(validations: [
        VInteger.greaterThan(0),
        VInteger.lessThan(300),
      ]),
      'siblings': FInteger(validations: []),
    }),
    'Issue': Document(fields: {
      'title': FString(),
      'description': FString(
        validations: [
          VString.longerThan(5),
          VString.shorterThan(128),
        ],
      ),
      'weight': FInteger(
        validations: [
          VInteger.greaterThan(0),
          VInteger.lessThan(6),
        ],
      ),
      'state': FString(),
    })
  },
);
