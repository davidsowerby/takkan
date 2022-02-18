import 'package:takkan_script/schema/schema.dart';

abstract class ServerCodeGenerator {
  bool generate({required Schema schema});

  Future<bool> exportCode({required String exportPath});
}
