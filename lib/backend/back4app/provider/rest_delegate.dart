import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/rest_delegate.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/document_id.dart';

class Back4AppRestDelegate extends DefaultRestDataProviderDelegate {
  Back4AppRestDelegate(DataProvider parent) : super(parent);

  @override
  Future<DeleteResult> deleteDocument({required DocumentId documentId}) async {
    final String doc = documentUrl(documentId);
    final dio.Response response = await dio.Dio(dio.BaseOptions(headers: instanceConfig.headers))
            .delete(doc);

    if (response.statusCode == HttpStatus.ok) {
      logType(this.runtimeType)
          .d('Data provider deleted document ${documentId.fullReference}');
      return DeleteResult(
        data: response.data,
        success: true,
        documentClass: documentId.documentClass,
        objectId: documentId.objectId,
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }
}
