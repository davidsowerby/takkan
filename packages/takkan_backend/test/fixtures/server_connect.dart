import 'package:dio/dio.dart' as dio;
import 'package:takkan_backend/backend/data_provider/server_connect.dart';

class MockRestServerConnect extends DefaultRestServerConnect {
  MockRestServerConnect(this.dioClient);
  final dio.Dio dioClient;

  @override
  dio.Dio client(dio.BaseOptions options) {
    return dioClient;
  }
}
