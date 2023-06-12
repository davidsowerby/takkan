import 'package:dio/dio.dart';
import 'package:takkan_schema/common/exception.dart';

import 'url_builder.dart';

abstract class ResultTransformer {
  Map<String, dynamic> transform({
    required Response<dynamic> rawResponse,
    required URLRequest requestType,
  });

  List<Map<String, dynamic>> transformList({
    required Response<dynamic> rawResponse,
    required URLRequest requestType,
  });
}

class DefaultResultTransformer implements ResultTransformer {
  @override
  Map<String, dynamic> transform({
    required Response<dynamic> rawResponse,
    required URLRequest requestType,
  }) {
    switch (requestType) {
      case URLRequest.documentItem:
      case URLRequest.documentList:
        throw UnimplementedError(
            'What would these be useful for, if anything?');
      case URLRequest.deleteDoc:
      case URLRequest.createDoc:
      case URLRequest.readDoc:
      case URLRequest.updateDoc:
      case URLRequest.function:
        final Map<String, dynamic> data =
            rawResponse.data as Map<String, dynamic>;
        return data;
      case URLRequest.functionItem:
        final Map<String, dynamic> data =
            rawResponse.data as Map<String, dynamic>;
        final List<dynamic> result = data['result'] as List<dynamic>;
        return result[0] as Map<String, dynamic>;
      case URLRequest.functionList:
        return transformList(
            rawResponse: rawResponse, requestType: requestType)[0];
    }
  }

  @override
  List<Map<String, dynamic>> transformList({
    required Response<dynamic> rawResponse,
    required URLRequest requestType,
  }) {
    switch (requestType) {
      case URLRequest.documentItem:
      case URLRequest.documentList:
        throw UnimplementedError(
            'What would these be useful for, if anything?');
      case URLRequest.functionItem:
      case URLRequest.functionList:
        {
          final Map<String, dynamic> data =
              rawResponse.data as Map<String, dynamic>;
          final List<dynamic> result = data['result'] as List<dynamic>;

          return result.map((e) => e as Map<String, dynamic>).toList();
        }

      case URLRequest.createDoc:
      case URLRequest.readDoc:
      case URLRequest.updateDoc:
      case URLRequest.deleteDoc:
        throw const TakkanException('Not done yet');

      case URLRequest.function:
        throw const TakkanException(
            "function should be processed by 'transform' method");
    }
  }
}
