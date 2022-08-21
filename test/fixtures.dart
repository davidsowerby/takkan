import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

class FakeTakkanSchemaLoader extends Fake implements TakkanSchemaLoader {
  @override
  Future<Schema> load(SchemaSource source) async {
    return Schema(
      name: 'test',
      version: const Version(number: 0),
    );
  }
}

Matcher throwsTakkanException = throwsA(isA<TakkanException>());
