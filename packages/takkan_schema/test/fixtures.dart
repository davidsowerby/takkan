// ignore_for_file: avoid_implementing_value_types

import 'package:mocktail/mocktail.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/schema/document/document.dart';
import 'package:takkan_schema/schema/document/permissions.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:test/test.dart';

class FakeTakkanSchemaLoader extends Fake implements TakkanSchemaLoader {
  @override
  Future<Schema> load(SchemaSource source) async {
    return Schema(
      version: const Version(versionIndex: 0),
    );
  }
}

Matcher throwsTakkanException = throwsA(isA<TakkanException>());

// ignore: strict_raw_type
class MockField extends Mock implements Field {}
class MockFieldDiff extends Mock implements FieldDiff {}
class MockDocument extends Mock implements Document {}
class MockPermissions extends Mock implements Permissions {}

