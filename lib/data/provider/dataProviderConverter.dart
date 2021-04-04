import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/provider/dataProvider.dart';

class PDataProviderConverter {

  static final elementKey='-dataProvider-';

  static PDataProvider fromJson(Map<String, dynamic> json) {
    if (json==null) return null;
    final providerType = json[elementKey];
    switch (providerType) {
      case "PRestDataProvider":
        return PRestDataProvider.fromJson(json);
      default:
        throw PreceptException("DataProvider type '$providerType' not recognised");
    }
  }

  static Map<String, dynamic> toJson(PDataProvider object) {
    if (object==null) return null;
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[elementKey] = type.toString();
    return jsonMap;
  }
}
