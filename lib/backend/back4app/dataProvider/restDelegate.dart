import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/restDelegate.dart';
import 'package:precept_backend/backend/dataProvider/result.dart';
import 'package:precept_backend/backend/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/provider/documentId.dart';

class Back4AppRestDelegate extends DefaultRestDataProviderDelegate {
  Back4AppRestDelegate(DataProvider parent) : super(parent);

  @override
  Future<DeleteResult> deleteDocument({required DocumentId documentId}) async {
    final String doc = documentUrl(documentId);
    final dio.Response response = await dio.Dio(
            dio.BaseOptions(headers: appConfig.headers(parent.config, config)))
        .delete(doc);

    if (response.statusCode == HttpStatus.ok) {
      logType(this.runtimeType)
          .d('Data provider deleted document ${documentId.toKey}');
      return DeleteResult(
        data: response.data,
        success: true,
        path: documentId.path,
        itemId: documentId.itemId,
      );
    }
    throw APIException(
        message: response.statusMessage ?? 'Unknown',
        statusCode: response.statusCode ?? -999);
  }
}
