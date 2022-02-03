
import 'package:dio/dio.dart' as dio;
import 'package:precept_backend/backend/app/app_config.dart';

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

Future<dynamic> execute({required String function, Map<String,dynamic> params=const {}}) async {
  final instanceConfig = await _loadConfig();
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
  return config.instance(
    segment: 'precept',
    instance: 'precept-test',
  );
}


