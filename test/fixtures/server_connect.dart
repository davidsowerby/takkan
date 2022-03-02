import 'package:dio/dio.dart' as dio;
import 'package:precept_backend/backend/data_provider/server_connect.dart';

class MockRestServerConnect extends DefaultRestServerConnect {
  final dio.Dio dioClient;

  MockRestServerConnect(this.dioClient);

  dio.Dio client(dio.BaseOptions options) {
    return dioClient;
  }
}
