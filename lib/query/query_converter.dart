import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/rest_query.dart';

/// JSON converter for [PQuery] sub-classes
class PQueryConverter implements JsonConverter<PQuery, Map<String, dynamic>> {
  static final elementKey = '-type-';

  const PQueryConverter();

  @override
  PQuery fromJson(Map<String, dynamic> json) {
    final String? typeName = json[elementKey];
    json.remove(elementKey);
    switch (typeName) {
      case 'PGetDocument':
        return PGetDocument.fromJson(json);
      case 'PGetStream':
        return PGetStream.fromJson(json);
      case 'PGraphQLQuery':
        return PGraphQLQuery.fromJson(json);
      case 'PRestQuery':
        return PRestQuery.fromJson(json);
      default:
        String msg = 'Conversion required for $typeName';
        logName('PQueryConverter').e(msg);
        throw PreceptException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(PQuery object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = Map();
    jsonMap[elementKey] = type.toString();
    switch (type) {
      case PGetDocument:
      case PGetStream:
      case PGraphQLQuery:
      case PRestQuery:
        {
          jsonMap.addAll(object.toJson());
          return jsonMap;
        }
      default:
        throw PreceptException("Conversion required for $type");
    }
  }
}
