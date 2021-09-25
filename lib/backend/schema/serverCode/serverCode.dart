import 'package:precept_script/schema/schema.dart';

abstract class ServerCodeGenerator {
  bool generate({required PSchema schema});

  Future<bool> exportCode({required String exportPath});
}
