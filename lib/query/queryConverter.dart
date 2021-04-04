import 'package:precept_script/common/exception.dart';
import 'package:precept_script/query/query.dart';

/// JSON converter for [PQuery] sub-classes
class PQueryConverter {
  static final elementKey = '-type-';
  static PQuery fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final String typeName = json[elementKey];
    json.remove(elementKey);
    switch (typeName) {
      case 'PGet':
        return PGet.fromJson(json);
      case 'PGetStream':
        return PGetStream.fromJson(json);
      default:
        throw PreceptException("Conversion required for $typeName");
    }
  }

  static Map<String, dynamic> toJson(PQuery object) {
    if (object == null) {
      return null;
    }
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = Map();
    jsonMap[elementKey] = type.toString();
    switch (type) {
      case PGet:
        {
          final PGet obj = object;
          jsonMap.addAll(obj.toJson());
          return jsonMap;
        }
      default:
        throw PreceptException("Conversion required for $type");
    }
  }
}
