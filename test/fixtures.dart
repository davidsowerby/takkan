import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

class FakePreceptSchemaLoader extends Fake implements PreceptSchemaLoader {
  Future<Schema> load(SchemaSource source) async {
    return Schema(
      name: 'test',
      version: Version(number: 0),
    );
  }
}

Matcher throwsPreceptException = throwsA(isA<PreceptException>());
