import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/version.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

class FakePreceptSchemaLoader extends Fake implements PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source) async {
    return PSchema(
      name: 'test',
      version: PVersion(number: 0),
    );
  }
}

Matcher throwsPreceptException = throwsA(isA<PreceptException>());
