import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/version.dart';
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
