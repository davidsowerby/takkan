import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/app/app_config_loader.dart';

Future<List<dynamic>> fetch(
    {required String documentType, required String objectId}) async {
  final instanceConfig = await _loadConfig();
  final dio.Response response =
      await dio.Dio(dio.BaseOptions(headers: instanceConfig.headers)).get(
    'https://parseapi.back4app.com/classes/$documentType',
    queryParameters: {},
  );
  return response.data['results'];
}

Future<dio.Response> execute(
    {required String function, Map<String, dynamic> params = const {}}) async {
  final instanceConfig = await _loadConfig();
  print('Calling Cloud Function \'$function\'');
  final dio.Response response =
      await dio.Dio(dio.BaseOptions(headers: instanceConfig.headers)).post(
    'https://parseapi.back4app.com/functions/$function',
    queryParameters: params,
  );
  return response;
}

Future<InstanceConfig> _loadConfig() async {
  AppConfigFileLoader loader = AppConfigFileLoader();
  final AppConfig config = await loader.load();
  return config.group('takkan').instance('test');

}

String get serverCodeDeployDir {
  final String userHome = Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      'User Home not identified';
  return '$userHome/b4a/takkan/takkan-test/cloud';
}

Future<dio.Response> prepareFrameworkTest({required int version, bool callInitPrecept=true}) async {
  final deployDir = await copyReference(version);
  await deploy(deployDir);
  final isResettableResponse = await execute(function: 'isResettable');
  final resettable = isResettableResponse.data['result'];
  if (!resettable) {
    throw Exception(
        'To run this test, target Back4App instance must have environment variable \'resettable=true\'');
  }
  final dio.Response resetResponse=await execute(function: 'resetInstance');
  final purged=resetResponse.data['result']['purged classes'];
  final deleted=resetResponse.data['result']['deleted classes'];
  print('Instance reset with following actions: \n');
  print("all entries purged from these classes: \n${purged.join('\n')}\n");
  print("these classes deleted : \n${deleted.join('\n')}\n");
  if(callInitPrecept){
    final dio.Response initPreceptResponse=await execute(function: 'initPrecept');
    return initPreceptResponse;
  }
  return resetResponse;
}

Future<Directory> copyReference(int version) async {
  final Directory reference = Directory('test/reference/$version/cloud');
  final Directory deployDir = Directory(serverCodeDeployDir);
  await deployDir.delete(recursive: true);
  await deployDir.create();
  final files = await reference.list().toList();
  for (FileSystemEntity f in files) {
    final fileName = f.path.split('/').last;
    if (f is File) {
      await f.copy('$serverCodeDeployDir/$fileName');
    }
  }
  print(
      '${files.length} reference files copied to from ${reference.path} to ${deployDir.path}');
  return deployDir;
}

Future<int> deploy(Directory deployDir) async {
  print('Compiling generator');
  var process = await Process.start(
      'bash',
      [
        '-c',
        'b4a deploy',
      ],
      workingDirectory: deployDir.path);
  process.stdout.transform(utf8.decoder).forEach(print);
  process.stderr.transform(utf8.decoder).forEach(print);
  final exitCode = await process.exitCode;
  return exitCode;
}
