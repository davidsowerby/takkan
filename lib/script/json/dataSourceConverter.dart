import 'package:precept_schema/common/exception.dart';
import 'package:precept_script/script/dataSource.dart';

class PDataSourceConverter {
  static final elementKey = '-type-';
  static PDataSource fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final String typeName = json[elementKey];
    json.remove(elementKey);
    switch (typeName) {
      case 'PDataGet':
        return PDataGet.fromJson(json);
      case 'PDataStream':
        return PDataStream.fromJson(json);
      default:
        throw PreceptException("Conversion required for $typeName");
    }
  }

  static Map<String, dynamic> toJson(PDataSource object) {
    if (object == null) {
      return null;
    }
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = Map();
    jsonMap[elementKey] = type.toString();
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
