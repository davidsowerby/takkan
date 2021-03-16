import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

abstract class ScriptHandler{
  Future<bool> saveScript({PScript script});
  Future<bool> saveSchema({PSchema script});
  Future<Map<String,dynamic>> loadScript({String scriptName, int scriptVersion});
  Future<Map<String,dynamic>> loadSchema({String schemaName, int schemaVersion});
}