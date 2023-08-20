import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/data/provider/document_id.dart';

import '../app/app_config.dart';

abstract class URLBuilder {
  URLComposition build({
    required URLRequest request,
    required InstanceConfig instanceConfig,
    String? documentClass,
    String? functionName,
    DocumentId? documentId,
    Map<String, dynamic>? params,
  });
}

class DefaultURLBuilder implements URLBuilder {
  @override
  URLComposition build({
    required URLRequest request,
    required InstanceConfig instanceConfig,
    String? documentClass,
    String? functionName,
    DocumentId? documentId,
    Map<String, dynamic>? params,
  }) {
    switch (request) {
      case URLRequest.documentItem:
      case URLRequest.documentList:
      case URLRequest.function:
      case URLRequest.functionItem:
      case URLRequest.functionList:
        final String url = '${instanceConfig.functionEndpoint}/$functionName';
        return URLComposition(url: url, paramsAsData: params);
      case URLRequest.readDoc:
      case URLRequest.updateDoc:
      case URLRequest.deleteDoc:
        {
          if (documentId != null) {
            final url =
                '${instanceConfig.documentEndpoint}/${documentId.documentClass}/${documentId.objectId}';
            return URLComposition(url: url);
          }
          const String msg = 'DocumentId is required';
          logType(runtimeType).e(msg);
          throw const TakkanException(msg);
        }
      case URLRequest.createDoc:
        return URLComposition(
            url: '${instanceConfig.documentEndpoint}/$documentClass');
    }
  }
}

class URLComposition {
  const URLComposition({required this.url, this.paramsAsData});

  final String url;
  final Map<String, dynamic>? paramsAsData;
}

///
/// - [documentItem] uses the [InstanceConfig.documentEndpoint] and must return a single document
/// - [documentList] uses the [InstanceConfig.documentEndpoint] and must return a 0..n list of documents
/// - [function] uses the [InstanceConfig.functionEndpoint] and will return whatever the function defines
/// - [functionItem] uses the [InstanceConfig.functionEndpoint] and must return a single document.  This is probably a function generated automatically by *takkan_server_code_generator*
/// - [functionList] uses the [InstanceConfig.functionEndpoint] and must return a 0..n list of documents.  This is probably a function generated automatically by *takkan_server_code_generator*
/// - [createDoc],[readDoc],[updateDoc],[deleteDoc] all use the  [InstanceConfig.documentEndpoint]  and operate on a single document identified by a [DocumentId].
enum URLRequest {
  documentItem,
  documentList,
  function,
  functionItem,
  functionList,
  createDoc,
  readDoc,
  updateDoc,
  deleteDoc
}
