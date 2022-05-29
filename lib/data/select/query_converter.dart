import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/data/select/rest_query.dart';

import '../../common/constants.dart';

/// JSON converter for [Query] sub-classes
class QueryConverter implements JsonConverter<Query, Map<String, dynamic>> {

  const QueryConverter();

  @override
  Query fromJson(Map<String, dynamic> json) {
    final String? typeName = json[jsonClassKey] as String?;
    json.remove(jsonClassKey);
    switch (typeName) {
      case 'GetDocument':
        return GetDocument.fromJson(json);
      case 'GetStream':
        return GetStream.fromJson(json);
      case 'GraphQLQuery':
        return GraphQLQuery.fromJson(json);
      case 'RestQuery':
        return RestQuery.fromJson(json);
      default:
        final String msg = 'Conversion required for $typeName';
        logName('QueryConverter').e(msg);
        throw TakkanException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(Query object) {
    final  Type type = object.runtimeType;
    final Map<String, dynamic> jsonMap = {};
    jsonMap[jsonClassKey] = type.toString();
    switch (type) {
      case GetDocument:
      case GetStream:
      case GraphQLQuery:
      case RestQuery:
        {
          jsonMap.addAll(object.toJson());
          return jsonMap;
        }
      default:
        final String msg='Conversion required for $type';
        logType(runtimeType).e(msg);
        throw TakkanException(msg);
    }
  }
}
