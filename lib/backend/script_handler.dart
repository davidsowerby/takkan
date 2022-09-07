import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/script/script.dart';

abstract class ScriptHandler {
  Future<bool> saveScript({required Script script});

  Future<bool> saveSchema({required Schema script});

  Future<Map<String, dynamic>> loadScript(
      {required String scriptName, required int scriptVersion});

  Future<Map<String, dynamic>> loadSchema(
      {required String schemaName, required int schemaVersion});
}
