import 'package:takkan_backend/backend/script_handler.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/script/script.dart';

class Back4AppScriptHandler implements ScriptHandler {
  @override
  Future<Map<String, dynamic>> loadSchema(
      {required String schemaName, required int schemaVersion}) {
    // TODO: implement loadSchema
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> loadScript(
      {required String scriptName, required int scriptVersion}) {
    // TODO: implement loadScript
    throw UnimplementedError();
  }

  @override
  Future<bool> saveSchema({required Schema script}) {
    // TODO: implement saveSchema
    throw UnimplementedError();
  }

  @override
  Future<bool> saveScript({required Script script}) {
    // TODO: implement saveScript
    throw UnimplementedError();
  }
}
