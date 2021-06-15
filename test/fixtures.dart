import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/schema/schema.dart';

class FakePreceptSchemaLoader extends Fake implements PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source) async {
    print('xxxxxxxxxxxxxxx');
    return PSchema(name: 'test');
  }
}

Matcher throwsPreceptException = throwsA(isA<PreceptException>());
