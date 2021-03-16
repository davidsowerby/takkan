import 'package:precept_backend/backend/scriptHandler.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

class Back4AppScriptHandler implements ScriptHandler {
  @override
  Future<Map<String, dynamic>> loadSchema({String schemaName, int schemaVersion}) {
    // TODO: implement loadSchema
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> loadScript({String scriptName, int scriptVersion}) {
    // TODO: implement loadScript
    throw UnimplementedError();
  }

  @override
  Future<bool> saveSchema({PSchema script}) {
    // TODO: implement saveSchema
    throw UnimplementedError();
  }

  @override
  Future<bool> saveScript({PScript script}) {
    // TODO: implement saveScript
    throw UnimplementedError();
  }
}
