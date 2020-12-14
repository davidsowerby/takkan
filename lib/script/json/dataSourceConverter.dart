import 'package:precept_script/common/exception.dart';
import 'package:precept_script/script/query.dart';
import 'package:json_annotation/json_annotation.dart';

class PDataSourceConverter
    implements JsonConverter<PDataSource, Map<String, dynamic>> {
  const PDataSourceConverter();

  @override
  PDataSource fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final String typeName = json["type"];
    json.remove("type");
    switch (typeName) {
      case "PDataGet":
        return PDataGet.fromJson(json);
      default:
        throw PreceptException("Conversion required for $typeName");
    }
  }

  @override
  Map<String, dynamic> toJson(PDataSource object) {
    if (object == null) {
      return null;
    }
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = Map();
    jsonMap["type"] = type.toString();
    switch (type) {
      case PDataGet:
        {
          final PDataGet obj = object;
          jsonMap.addAll(obj.toJson());
          return jsonMap;
        }
      default:
        throw PreceptException("Conversion required for $type");
    }
  }
}