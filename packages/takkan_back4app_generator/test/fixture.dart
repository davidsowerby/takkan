import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/app/app_config_loader.dart';

Future<List<dynamic>> fetch(
    {required String documentType, required String objectId}) async {
  final instanceConfig = await _loadConfig();
  final dio.Response<dynamic> response =
      await dio.Dio(dio.BaseOptions(headers: instanceConfig.headers)).get(
    'https://parseapi.back4app.com/classes/$documentType',
    queryParameters: {},
  );
  throw UnimplementedError();
  // return response.data['results'];
}

Future<dio.Response<dynamic>> execute(
    {required String function, Map<String, dynamic> params = const {}}) async {
  final instanceConfig = await _loadConfig();
  stdout.writeln("Calling Cloud Function '$function'");
  final dio.Response<dynamic> response =
      await dio.Dio(dio.BaseOptions(headers: instanceConfig.headers)).post(
    'https://parseapi.back4app.com/functions/$function',
    queryParameters: params,
  );
  return response;
}

Future<InstanceConfig> _loadConfig() async {
  const DefaultJsonFileLoader loader = DefaultJsonFileLoader();
  final jsonConfig = await loader.loadFile(filePath: 'takkan.json');
  final AppConfig config = AppConfig.fromData(data: jsonConfig);
  return config.group('takkan').instance('test');
}

String get serverCodeDeployDir {
  final String userHome = Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      'User Home not identified';
  return '$userHome/b4a/takkan/takkan-test/cloud';
}

Future<dio.Response<dynamic>> prepareFrameworkTest(
    {required int version, bool callInitPrecept = true}) async {
  final deployDir = await copyReference(version);
  await deploy(deployDir);
  final dio.Response<dynamic> isResettableResponse =
      await execute(function: 'isResettable');
  final bool resettable = isResettableResponse.data['result'] as bool? ?? false;
  if (!resettable) {
    throw Exception(
        "To run this test, target Back4App instance must have environment variable 'resettable=true'");
  }
  final dio.Response<dynamic> resetResponse =
      await execute(function: 'resetInstance');
  final purged = resetResponse.data['result']['purged classes'];
  final deleted = resetResponse.data['result']['deleted classes'];
  stdout.writeln('Instance reset with following actions: \n');
  stdout.writeln(
      "all entries purged from these classes: \n${purged.join('\n')}\n");
  stdout.writeln("these classes deleted : \n${deleted.join('\n')}\n");
  if (callInitPrecept) {
    final dio.Response<dynamic> initPreceptResponse =
        await execute(function: 'initTakkan');
    return initPreceptResponse;
  }
  return resetResponse;
}

Future<void> deploy(Directory deployDir) async {
  throw UnimplementedError();
}

Future<Directory> copyReference(int version) async {
  final Directory reference = Directory('test/reference/$version/cloud');
  final Directory deployDir = Directory(serverCodeDeployDir);
  await deployDir.delete(recursive: true);
  await deployDir.create();
  final files = await reference.list().toList();
  for (final FileSystemEntity f in files) {
    final fileName = f.path.split('/').last;
    if (f is File) {
      await f.copy('$serverCodeDeployDir/$fileName');
    }
  }
  stdout.writeln(
      '${files.length} reference files copied from ${reference.path} to ${deployDir.path}');
  return deployDir;
}
