import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/select/query.dart';
import 'package:takkan_script/data/select/rest_query.dart';

/// JSON converter for [Query] sub-classes
class QueryConverter implements JsonConverter<Query, Map<String, dynamic>> {
  static final elementKey = '-type-';

  const QueryConverter();

  @override
  Query fromJson(Map<String, dynamic> json) {
    final String? typeName = json[elementKey];
    json.remove(elementKey);
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
        String msg = 'Conversion required for $typeName';
        logName('QueryConverter').e(msg);
        throw PreceptException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(Query object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = Map();
    jsonMap[elementKey] = type.toString();
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
        throw PreceptException("Conversion required for $type");
    }
  }
}
