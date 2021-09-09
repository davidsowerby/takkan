import 'package:dio/dio.dart' as dio;
import 'package:precept_back4app_backend/backend/back4app/schema/schemaConverter.dart';
import 'package:precept_backend/backend/schema/upload.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/schema/schema.dart';

class Back4AppServerSchemaHandler implements ServerSchemaHandler {
  // final AppConfig appConfig;
  // final PBack4AppDataProvider config;

  Back4AppServerSchemaHandler();

  // Back4AppServerSchemaHandler({required this.appConfig,required  this.config});

  @override
  Future<bool> addRoles({
    required List<String> roles,
    required Map<String, String> headers,
  }) {
    // TODO: implement addRoles
    throw UnimplementedError();
  }

  /// This is temporary - it's bad because it needs the master key.  See [open issue](https://gitlab.com/precept1/precept_client/-/issues/61)
  @override
  Future<bool> createServerSchema({
    required PSchema preceptSchema,
    required String documentName,
    required Map<String, String> headers,
    required int version,
  }) async {
    final PDocument? document = preceptSchema.documents[documentName];
    if (document == null) {
      throw PreceptException(
          '\'$documentName\' is not a valid document name within schema \'${preceptSchema.name}\'');
    }
    final SchemaClass schemaClass = SchemaClass.fromPrecept(document);
    final json = schemaClass.toJson();
    final serverUrl = 'https://parseapi.back4app.com/';
    final String url = "${serverUrl}parse/schemas/${preceptSchema.name}";
    final dio.Response response =
        await dio.Dio(dio.BaseOptions(headers: headers)).post(url, data: json);
    return response.statusCode == 200;
  }

  /// This is temporary - it's bad because it needs the master key.  See [open issue](https://gitlab.com/precept1/precept_client/-/issues/61)
  /// It's only put instead of post otherwise the same as [createServerSchema]
  @override
  Future<bool> updateServerSchema({
    required PSchema preceptSchema,
    required String documentName,
    required Map<String, String> headers,
    required int version,
  }) async {
    // final PDocument? document = preceptSchema.documents[documentName];
    // if (document == null) {
    //   throw PreceptException(
    //       '\'$documentName\' is not a valid document name within schema \'${preceptSchema
    //           .name}\'');
    // }
    // final SchemaClass schemaClass = SchemaClass.fromPrecept(document);
    // final json = schemaClass.toJson();
    // final instanceConfig = appConfig.instanceConfig(config);
    // final String url = "${instanceConfig['serverUrl']}parse/schemas/${preceptSchema
    //     .name}";
    // final dio.Response response = await dio.Dio(
    //     dio.BaseOptions(headers: headers))
    //     .put(url,data: json);
    // return response.statusCode==200;
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getRawBackendSchema() async {
    // final instanceConfig = appConfig.instanceConfig(config);
    // final dio.Response response = await dio.Dio(dio.BaseOptions(
    //     headers: appConfig.headers(
    //         config, PRest(sessionTokenKey: 'sessionToken'))))
    //     .get('${instanceConfig['serverUrl']}parse/schemas');
    // return response.data;
    throw UnimplementedError();
  }
}
